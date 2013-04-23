<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s='http://www.w3.org/2005/sparql-results#'
	xmlns='http://www.w3.org/1999/xhtml'
	xmlns:xlink='http://www.w3.org/1999/xlink'
	xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
	xmlns:mon='http://monitor.unicefuganda.org/#'
>
<!--
	applied to reply of query `describe <Class>'
-->
<xsl:variable name='type' select='/rdf:RDF/*/@rdf:about'/>
<xsl:variable name='esc_type' select="concat(substring-before($type,'#'),'%23',substring-after($type,'#'))"/>
<xsl:variable name='helper' select="document(concat('/sparql?query=select * where {?p rdfs:domain &lt;',$esc_type,'&gt; . ?p rdfs:range ?r .}'))"/>
<xsl:variable name='literals' select="document('/sparql?query=select * where {?s rdfs:subClassOf rdf:Literal .}')/s:sparql/s:results/s:result/s:binding/s:uri"/>
<!--
	could also query rdfs:comment for properties but we need support for optional in sparql first
-->
<xsl:template match='rdf:RDF'>
<div class='jm'>
<!--<div class='header'><b><xsl:value-of select="substring-after($type,'#')"/></b> </div>-->
<xsl:apply-templates mode='add'/>
</div>
</xsl:template>
<xsl:template match='*' mode='add'>
<form name='add' method='get'>
	<table>
		<!--<tr><td>ID:</td><td><input type='text' name='ID'/></td></tr>-->
		<xsl:apply-templates select='$helper'/>
		<tr><input type='submit' value='add'/></tr>
	</table>
</form>
</xsl:template>

<!-- specialize for different types -->

<xsl:template match="*[@rdf:about='http://monitor.unicefuganda.org/#Report']" mode='add'>
<form name='add' method='get'>
	<table>
		<tr><textarea name="http://monitor.unicefuganda.org/#text" value=""/></tr>
		<!-- we need to attach to a site, one site at a time -->
		<tr>
			<select name="http://monitor.unicefuganda.org/#report">
				<xsl:for-each select="document('/sparql?query=select * where {?s a &lt;http://monitor.unicefuganda.org/%23Site&gt; .}')/s:sparql/s:results/s:result/s:binding/s:uri">
					<option><xsl:value-of select='.'/></option>
				</xsl:for-each>
			</select>
		</tr>
		<tr><input type='submit' value='add report'/></tr>

	</table>
</form>
</xsl:template>


<xsl:template match="s:result">
<xsl:variable name='tmp' select='.'/>
<xsl:variable name='range' select="s:binding[@name='r']/s:uri"/>
<tr>
<td><xsl:value-of select="substring-after(s:binding[@name='p']/s:uri,'#')"/>:</td>
<td>
<xsl:choose>
	<xsl:when test="$literals[text()=$tmp/s:binding[@name='r']/s:uri/text()]">
		<input type='text' name="{$tmp/s:binding[@name='p']/s:uri}" value=""/><!-- interesting browser escapes characters here -->
	</xsl:when>
	<xsl:otherwise>
		<select name="{$tmp/s:binding[@name='p']/s:uri}">
		<!-- we also ask for the type because of entailment we will get sub-classes --> 
		<!--<xsl:for-each select="document(concat('/sparql?query=select * where {?s a &lt;',substring-before($range,'#'),'%23',substring-after($range,'#'),'&gt;;a ?t .}'))/s:sparql/s:results/s:result/s:binding/s:uri">-->
		<option value='--' selected='true'>--</option>
		<xsl:for-each select="document(concat('/sparql?query=select * where {?s a &lt;',substring-before($range,'#'),'%23',substring-after($range,'#'),'&gt; .}'))/s:sparql/s:results/s:result/s:binding/s:uri">
			<!--<option value='{.}'><xsl:value-of select="substring-after(.,'#')"/></option>-->
			<option value='{.}'><xsl:value-of select="."/></option>
		</xsl:for-each>
		</select>
	</xsl:otherwise>
</xsl:choose>
</td>
</tr>
</xsl:template>

<!-- propertie to hide -->

<xsl:template match="s:result[s:binding[@name='p']/s:uri='http://www.w3.org/1999/02/22-rdf-syntax-ns#type']"/>
<xsl:template match="s:result[s:binding[@name='p']/s:uri='http://www.example.org/objrdf#id']"/>
<xsl:template match="s:result[s:binding[@name='p']/s:uri='http://www.example.org/objrdf#self']"/>
<xsl:template match="s:result[s:binding[@name='p']/s:uri='http://www.example.org/objrdf#prev']"/>
<xsl:template match="s:result[s:binding[@name='p']/s:uri='http://www.example.org/objrdf#next']"/>
<xsl:template match="s:result[s:binding[@name='p']/s:uri='http://monitor.unicefuganda.org/#time_stamp']"/>
</xsl:stylesheet>
