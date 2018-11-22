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
      table.sublines tr.entry { padding:0 6px; }
      table.sublines label { padding:0; margin:0; }
      table.sublines td { border: solid 1px black; }
      table.sublines td.n { text-align:left; }
      table.sublines td.d { text-align:center; }
      table.sublines td.a { text-align:right; }
      table.sublines td.b { text-align:center; }
      
      td.dorc       { text-align:center; }
      td.dorc label::after { content:none; }
      td.dorc label { border:solid 1px black; font-family:sans; background-color:#DDDDDD; }
      td.dorc input { height:0; width:0; opacity:0; }
      td.dorc span  { border:solid 1px black; width:1.5em; cursor:pointer; padding:0 4px; }
      td.dorc input:focus  { border: solid 1px blue; }

      td.dorc input ~ span.d { color: #999999; }
      td.dorc input ~ span.c { color: #000000; }
      td.dorc input:checked ~ span.d { color: #000000; }
      td.dorc input:checked ~ span.c { color: #999999; }

      label.two-way input { height:0; width:0; opacity:0; }
      label.two-way input ~ span.on   { display:none; }
      label.two-way input ~ span.off  { display:inline; }
      label.two-way input:checked ~ span.on  { display:inline; }
      label.two-way input:checked ~ span.off { display:none; }
      
    </xsl:text>
  </xsl:template>


  <!-- Next two to create shadow input element: -->
  <xsl:template match="*" mode="sublines_input_text">
    <xsl:value-of select="concat(@person,'|',@amount,';')" />
  </xsl:template>

  <xsl:template match="*" mode="sublines_shadow_input">
    <xsl:param name="field" />
    <xsl:variable name="name" select="concat('shadow_',$field/@name)" />
    <xsl:variable name="value">
      <xsl:apply-templates select="*[local-name()=../@row-name]" mode="sublines_input_text" />
    </xsl:variable>
    <input type="hidden" name="{$name}" value="{$value}" />
  </xsl:template>

  <!-- <xsl:template match="*" mode="sublines_person_option"> -->
  <!--   <xsl:param name="sel" /> -->
  <!--   <xsl:element name="option"> -->
  <!--     <xsl:attribute name="value"><xsl:value-of select="@id" /></xsl:attribute> -->
  <!--     <xsl:if test="$sel=@id"> -->
  <!--       <xsl:attribute name="selected">selected</xsl:attribute> -->
  <!--     </xsl:if> -->
  <!--     <xsl:value-of select="@name" /> -->
  <!--   </xsl:element> -->
  <!-- </xsl:template> -->

  <!-- <xsl:template match="*" mode="sublines_dorc"> -->
  <!--   <xsl:choose> -->
  <!--     <xsl:when test="@dorc=1">Take</xsl:when> -->
  <!--     <xsl:otherwise>Give</xsl:otherwise> -->
  <!--   </xsl:choose> -->
  <!-- </xsl:template> -->

  <!-- <xsl:template match="*" mode="sublines_line"> -->
  <!--   <xsl:param name="lookup" /> -->
  <!--   <xsl:variable name="id" select="@person" /> -->
  <!--   <xsl:variable name="pline" select="$lookup/*[local-name()=../@row-name][@id=$id]" /> -->
  <!--   <xsl:variable name="pos" select="position()" /> -->
  <!--   <tr> -->
  <!--     <td class="n"><xsl:value-of select="$pline/@name" /></td> -->
  <!--     <td class="d"><xsl:apply-templates select="." mode="sublines_dorc" /></td> -->
  <!--     <td class="a"><xsl:value-of select="@amount" /></td> -->
  <!--     <td class="b"><button type="button" name="delete" value="{$pos}"><xsl:value-of select="$ndash"/></button></td> -->
  <!--   </tr> -->
  <!-- </xsl:template> -->

  <!-- <xsl:template match="*[@rndx]" mode="sublines_line_entry"> -->
  <!--   <xsl:param name="joins" /> -->
  <!--   <xsl:param name="lookup" /> -->
  <!--   <xsl:param name="sel" /> -->
  <!--   <tr class="entry"> -->
  <!--     <td class="n"> -->
  <!--       <select name="person"> -->
  <!--         <xsl:apply-templates select="$lookup/*" mode="sublines_person_option"> -->
  <!--           <xsl:with-param name="sel" select="$sel" /> -->
  <!--         </xsl:apply-templates> -->
  <!--       </select> -->
  <!--     </td> -->
  <!--     <td class="dorc"> -->
  <!--       <label> -->
  <!--         <input type="checkbox" name="dorc" value="debit" checked="checked" /> -->
  <!--         <span class="d">Give</span> -->
  <!--         <span class="c">Take</span> -->
  <!--       </label> -->
  <!--     </td> -->
  <!--     <td class="a"> -->
  <!--       <input type="number" name="amount" /> -->
  <!--     </td> -->
  <!--     <td class="b"> -->
  <!--       <button type="button" name="add">Add</button> -->
  <!--     </td> -->
  <!--   </tr> -->
  <!-- </xsl:template> -->

  <!-- <xsl:template match="*" mode="sublines_table"> -->
  <!--   <xsl:param name="lookup" /> -->
  <!--   <xsl:param name="field" /> -->
  <!--   <xsl:variable name="rows" select="*[local-name()=../@row-name]" /> -->
  <!--   <xsl:variable name="joins" select="$field/../field[@join=$field/@name]" /> -->

  <!--   <xsl:variable name="sel"> -->
  <!--     <xsl:call-template name="get_var_value"> -->
  <!--       <xsl:with-param name="name" select="'person'" /> -->
  <!--     </xsl:call-template> -->
  <!--   </xsl:variable> -->

  <!--   <xsl:apply-templates select="." mode="sublines_shadow_input"> -->
  <!--     <xsl:with-param name="field" select="$field" /> -->
  <!--   </xsl:apply-templates> -->

  <!--   <table class="sublines"> -->
  <!--     <xsl:apply-templates select="$rows" mode="sublines_line"> -->
  <!--       <xsl:with-param name="lookup" select="$lookup" /> -->
  <!--     </xsl:apply-templates> -->
  <!--     <xsl:apply-templates select="." mode="sublines_line_entry"> -->
  <!--       <xsl:with-param name="joins" select="$joins" /> -->
  <!--       <xsl:with-param name="lookup" select="$lookup" /> -->
  <!--       <xsl:with-param name="sel" select="$sel" /> -->
  <!--     </xsl:apply-templates> -->
  <!--   </table> -->
  <!-- </xsl:template> -->

  <!-- <xsl:template match="field[@type='sublines']" mode="show_transaction_details"> -->
  <!--   <xsl:variable name="rname" select="@result" /> -->
  <!--   <xsl:variable name="result" select="/*/*[@rndx][local-name()=current()/@result]" /> -->
  <!--   <xsl:variable name="lookup" select="/*/*[@rndx][local-name()=current()/@lookup]" /> -->

  <!--   <xsl:apply-templates select="$result" mode="sublines_table"> -->
  <!--     <xsl:with-param name="lookup" select="$lookup" /> -->
  <!--     <xsl:with-param name="field" select="." /> -->
  <!--   </xsl:apply-templates> -->
  <!-- </xsl:template> -->

  <!-- <xsl:template match="field[@type='sublines']" mode="construct_input_old"> -->
  <!--   <xsl:param name="data" /> -->
  <!--   <input type="hidden" name="{@name}" data-sfw-shadow="true" /> -->
  <!--   <form data-sfw-class="sublines" -->
  <!--        data-sfw-input="true" -->
  <!--        name="{@name}" -->
  <!--        tabindex="0"> -->

  <!--     <xsl:apply-templates select="." mode="show_transaction_details" /> -->

  <!--   </form> -->
  <!-- </xsl:template> -->

  <!-- <xsl:template match="field[@type='sublines'][@result][@action='replotting']"> -->
  <!--   <xsl:apply-templates select="." mode="show_transaction_details" /> -->
  <!-- </xsl:template> -->

  <xsl:template match="field[@type='two-way']/states" mode="make_display_span">
    <xsl:param name="state" />
    <xsl:param name="position" />

    <xsl:variable name="label_on">
      <xsl:choose>
        <xsl:when test="@on"><xsl:value-of select="@on" /></xsl:when>
        <xsl:otherwise>on</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="label_off">
      <xsl:choose>
        <xsl:when test="@off"><xsl:value-of select="@off" /></xsl:when>
        <xsl:otherwise>off</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pos_on" select="count(@on/preceding-sibling::*)" />
    <xsl:variable name="pos_off" select="count(@off/preceding-sibling::*)" />

    <xsl:variable name="label_left">
      <xsl:choose>
        <xsl:when test="$pos_on &lt; $pos_off">
          <xsl:value-of select="$label_on" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$label_off" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="label_right">
      <xsl:choose>
        <xsl:when test="$pos_on &lt; $pos_off">
          <xsl:value-of select="$label_off" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$label_on" />
        </xsl:otherwise>
      </xsl:choose>
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

    <xsl:element name="span">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$position=0">off</xsl:when>
          <xsl:when test="$position=1">on</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="$label_left" />
      <xsl:value-of select="$arrow" />
      <xsl:value-of select="$label_right" />
    </xsl:element>

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

    <label class="two-way" for="{@name}">
      <xsl:element name="input">
        <xsl:attribute name="type">checkbox</xsl:attribute>
        <xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
        <xsl:if test="$state='on'">
          <xsl:attribute name="checked">checked</xsl:attribute>
        </xsl:if>
      </xsl:element>
      <xsl:apply-templates select="states" mode="make_display_span">
        <xsl:with-param name="position" select="0" />
        <xsl:with-param name="state" select="$state" />
      </xsl:apply-templates>
      <xsl:apply-templates select="states" mode="make_display_span">
        <xsl:with-param name="position" select="1" />
        <xsl:with-param name="state" select="$state" />
      </xsl:apply-templates>
    </label>
  </xsl:template>

  <xsl:template match="field[@type='two-way']" mode="get_value">
    <xsl:param name="data" />
    
  </xsl:template>

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

    <table class="sublines" data-sfw-class="sublines" data-sfw-input="true" name="{@name}">
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

    <input type="hidden" name="{@name}" data-sfw-shadow="true" />
    <xsl:apply-templates select="." mode="build_lines" />

  </xsl:template>

  <xsl:template match="field[@type='sublines'][@result][@action='replotting']">
    <xsl:apply-templates select="." mode="build_lines" />
  </xsl:template>

</xsl:stylesheet>
