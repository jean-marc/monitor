<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s='http://www.w3.org/2005/sparql-results#'
	xmlns='http://www.w3.org/1999/xhtml'
	xmlns:xlink='http://www.w3.org/1999/xlink'
	xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
	xmlns:mon='http://monitor.unicefuganda.org/#'
	xmlns:geo='http://www.w3.org/2003/01/geo/wgs84_pos#'
>
<xsl:template match='mon:Site'>
<div>
	<!--<xsl:value-of select='mon:time_stamp_v'/> |-->
	<xsl:value-of select='mon:organization/@rdf:resource'/> |
	<a href="{concat('http://maps.google.com/maps?q=',geo:lat,',',geo:long,'&amp;iwloc=A&amp;hl=en')}">map</a>
</div>
</xsl:template>
</xsl:stylesheet>
