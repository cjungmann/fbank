<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="html">

  <xsl:variable name="ndash" select="'&#8211;'" />

  <xsl:template name="sublines_css_styles">
    <xsl:text>
      div.sublines tr.entry { padding:0 6px; }
      div.sublines label { padding:0; margin:0; }
      div.sublines td { border: solid 1px black; }
      
      label.two-way input { height:0;width:0;position:fixed; }
      label.two-way input:focus ~ * { border: solid 1px blue; }
      label.two-way input ~ span.on   { display:none; }
      label.two-way input ~ span.off  { display:inline; }
      label.two-way input:checked ~ span.on  { display:inline; }
      label.two-way input:checked ~ span.off { display:none; }
      label.two-way span span    { color:#CCCCCC; font-weight:bold; }
      label.two-way span.picked_label { color: #3366FF; }
    </xsl:text>
  </xsl:template>


  <xsl:template match="@*" mode="sublines_input_text">
    <xsl:value-of select="." />
    <xsl:choose>
      <xsl:when test="position()=last()">;</xsl:when>
      <xsl:otherwise>|</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="sublines_input_text">
    <xsl:apply-templates select="@*" mode="sublines_input_text" />
  </xsl:template>

  <xsl:template match="*" mode="sublines_saved_input">
    <xsl:param name="field" />

    <xsl:variable name="name" select="$field/@name" />

    <xsl:variable name="value">
      <xsl:apply-templates select="*[local-name()=../@row-name]" mode="sublines_input_text" />
    </xsl:variable>

    <input type="hidden" name="{$name}" value="{$value}" data-xml-skip="true" />
  </xsl:template>


  <xsl:template match="field[@type='two-way']" mode="get_label_text">
    <xsl:param name="state" />

    <xsl:choose>
      <xsl:when test="$state='on' or $state='1'">
        <xsl:choose>
          <xsl:when test="states/@on"><xsl:value-of select="states/@on" /></xsl:when>
          <xsl:otherwise>on</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="states/@off"><xsl:value-of select="states/@off" /></xsl:when>
          <xsl:otherwise>off</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="two-way-pos">
    <xsl:param name="attrib" select="/.." />
    <xsl:choose>
      <xsl:when test="$attrib">
        <xsl:variable name="par" select="$attrib/.." />
        <xsl:variable name="both" select="$par/@on | $par/@off" />
        <xsl:choose>
          <xsl:when test="count($both)=2">
            <xsl:choose>
              <xsl:when test="local-name($attrib)=local-name($both[1])">1</xsl:when>
              <xsl:when test="local-name($attrib)=local-name($both[2])">2</xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="field[@type='two-way']" mode="make_label_span">
    <xsl:param name="state" />    <!-- on or off -->
    <xsl:param name="position" /> <!-- 0 for left/top or 1 for right/bottom -->
    <xsl:param name="side" />     <!-- 0 for left/top or 1 for right/bottom -->

    <xsl:variable name="label_on">
      <xsl:apply-templates select="." mode="get_label_text">
        <xsl:with-param name="state" select="1" />
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="label_off">
      <xsl:apply-templates select="." mode="get_label_text" />
    </xsl:variable>

    <xsl:variable name="pos_on">
      <xsl:call-template name="two-way-pos">
        <xsl:with-param name="attrib" select="states/@on" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="pos_off">
      <xsl:call-template name="two-way-pos">
        <xsl:with-param name="attrib" select="states/@off" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:element name="span">
      <xsl:if test="$position = $side">
        <xsl:attribute name="class">picked_label</xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$pos_off &gt; $pos_on">
          <xsl:choose>
            <xsl:when test="$side='0'">
              <xsl:value-of select="$label_on" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$label_off" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$side='0'">
              <xsl:value-of select="$label_off" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$label_on" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>

  </xsl:template>


  <xsl:template match="field[@type='two-way']" mode="make_display_span">
    <xsl:param name="state" />     <!-- on or off -->
    <xsl:param name="position" />  <!-- left/top or right/botton -->

    <xsl:variable name="label_on">
      <xsl:apply-templates select="." mode="get_label_text">
        <xsl:with-param name="state" select="1" />
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="label_off">
      <xsl:apply-templates select="." mode="get_label_text" />
    </xsl:variable>

    <xsl:variable name="pos_on">
      <xsl:call-template name="two-way-pos">
        <xsl:with-param name="attrib" select="states/@on" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="pos_off">
      <xsl:call-template name="two-way-pos">
        <xsl:with-param name="attrib" select="states/@off" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="arrow">
      <xsl:choose>
        <xsl:when test="$pos_on &lt; $pos_off">
          <xsl:choose>
            <xsl:when test="$position=0">==&gt;&gt;</xsl:when>
            <xsl:otherwise>&lt;&lt;==</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$position=1">==&gt;&gt;</xsl:when>
            <xsl:otherwise>&lt;&lt;==</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="class">
      <xsl:choose>
        <xsl:when test="$position=0">off</xsl:when>
        <xsl:when test="$position=1">on</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <span class="{$class}">
      <xsl:apply-templates select="." mode="make_label_span">
        <xsl:with-param name="state" select="$state" />
        <xsl:with-param name="position" select="$position" />
        <xsl:with-param name="side" select="0" />
      </xsl:apply-templates>

      <xsl:value-of select="$arrow" />

      <xsl:apply-templates select="." mode="make_label_span">
        <xsl:with-param name="state" select="$state" />
        <xsl:with-param name="position" select="$position" />
        <xsl:with-param name="side" select="1" />
      </xsl:apply-templates>
    </span>
  </xsl:template>

  <xsl:template match="field[@type='two-way']" mode="construct_input">
    <xsl:param name="data" />

    <xsl:variable name="val">
      <xsl:if test="$data">
        <xsl:value-of select="$data/@*[local-name()=current()/@name]" />
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="state">
      <xsl:choose>
        <xsl:when test="$val='1'">on</xsl:when>
        <xsl:when test="$val='0'">off</xsl:when>
        <xsl:when test="states/@default"><xsl:value-of select="states/@default" /></xsl:when>
        <xsl:otherwise>off</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <label class="two-way" onselectstart="return false">
      <xsl:element name="input">
        <xsl:attribute name="type">checkbox</xsl:attribute>
        <xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
        <xsl:if test="$state='on'">
          <xsl:attribute name="checked">checked</xsl:attribute>
        </xsl:if>
      </xsl:element>
      <xsl:apply-templates select="." mode="make_display_span">
        <xsl:with-param name="position" select="0" />
        <xsl:with-param name="state" select="$state" />
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="make_display_span">
        <xsl:with-param name="position" select="1" />
        <xsl:with-param name="state" select="$state" />
      </xsl:apply-templates>
    </label>
  </xsl:template>

  <xsl:template match="field[@type='two-way']" mode="get_value">
    <xsl:param name="data" />

    <xsl:variable name="val">
      <xsl:if test="$data">
        <xsl:value-of select="$data/@*[local-name()=current()/@name]" />
      </xsl:if>
    </xsl:variable>

    <xsl:apply-templates select="." mode="get_label_text">
      <xsl:with-param name="state" select="$val" />
    </xsl:apply-templates>
    
  </xsl:template>

  <xsl:template match="field[@type='two-way']" mode="def_css_class">def_center</xsl:template>

  <!-- New templates for more generic construction -->
  <xsl:template match="field[@join]" mode="sublines_entry_fields">
    <xsl:element name="td">
      <xsl:attribute name="class">
        <xsl:apply-templates select="." mode="def_css_class" />
      </xsl:attribute>
      <xsl:apply-templates select="." mode="construct_input" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="field[@type='sublines']" mode="sublines_line_entry">
    <xsl:param name="joins" />
    <tr class="sublines_entry">
      <xsl:apply-templates select="$joins" mode="sublines_entry_fields" />
      <td>
        <button type="button" name="add">+</button>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="field" mode="sublines_extra_cell">
    <xsl:param name="data" />
    <xsl:element name="td">

      <xsl:attribute name="class">
        <xsl:apply-templates select="." mode="def_css_class" />
      </xsl:attribute>

      <xsl:apply-templates select="." mode="get_value">
        <xsl:with-param name="data" select="$data" />
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="sublines_extra_row">
    <xsl:param name="joins" />
    <xsl:variable name="pos" select="position()" />
    <tr>
      <xsl:apply-templates select="$joins" mode="sublines_extra_cell">
        <xsl:with-param name="data" select="." />
      </xsl:apply-templates>
      <td>
        <button type="button" name="delete" value="{$pos}"><xsl:value-of select="$ndash" /></button>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="field[@type='sublines']" mode="sublines_extra_rows">
    <xsl:param name="joins" />

    <xsl:variable name="result" select="/*/*[@rndx][local-name()=current()/@result]" />
    <xsl:variable name="rows" select="$result/*[local-name()=$result/@row-name]" />

    <xsl:apply-templates select="$rows" mode="sublines_extra_row">
      <xsl:with-param name="joins" select="$joins" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="field[@type='sublines']" mode="build_lines">
    <xsl:variable name="joins" select="../field[@join=current()/@name]" />
    <xsl:variable name="result" select="/*/*[@rndx][local-name()=current()/@result]" />

    <xsl:apply-templates select="$result" mode="sublines_saved_input">
      <xsl:with-param name="field" select="." />
    </xsl:apply-templates>
    
    <table>
      <xsl:apply-templates select="." mode="sublines_extra_rows">
        <xsl:with-param name="joins" select="$joins" />
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="sublines_line_entry">
        <xsl:with-param name="joins" select="$joins" />
      </xsl:apply-templates>
    </table>
  </xsl:template>

  <xsl:template match="field[@type='sublines'][@result]" mode="construct_input">
    <xsl:param name="data" />

    <!-- <input type="hidden" name="{@name}" data-sfw-shadow="true" /> -->
    <div class="sublines" data-sfw-class="sublines" data-sfw-input="true" name="{@name}">
      <xsl:apply-templates select="." mode="build_lines" />
    </div>

  </xsl:template>

  <xsl:template match="field[@type='sublines'][@result][@action='replotting']">
    <xsl:apply-templates select="." mode="build_lines" />
  </xsl:template>

</xsl:stylesheet>
