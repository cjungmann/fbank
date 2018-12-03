<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="html">

    <xsl:output
      method="xml"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
      version="1.0"
      indent="yes"
      omit-xml-declaration="yes"
      encoding="utf-8"/>

    <xsl:template match="@*" mode="tdetail_table_cell">
      <td><xsl:value-of select="." /></td>
    </xsl:template>

    <xsl:template match="*" mode="tdetail_table_row">
      <tr>
        <xsl:apply-templates select="@*" mode="tdetail_table_cell" />
      </tr>
    </xsl:template>

    <xsl:template match="*[@rndx]" mode="tdetail_table">
      <table>
        <xsl:apply-templates select="*[local-name()=../@row-name]" mode="tdetail_table_row" />
      </table>
    </xsl:template>

    <xsl:template match="field[@type='TDetail']" mode="display_value">
      <xsl:variable name="result" select="/*/*[@rndx][local-name()=current()/@result]" />
      <xsl:apply-templates select="$result" mode="tdetail_table" />
    </xsl:template>

</xsl:stylesheet>
