<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s='http://www.w3.org/2005/sparql-results#'
	xmlns:xlink='http://www.w3.org/1999/xlink'
	xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
	xmlns:mon='http://monitor.unicefuganda.org/#'
	xmlns:geo='http://www.w3.org/2003/01/geo/wgs84_pos#'
	xmlns:svg='http://www.w3.org/2000/svg'
	xmlns='http://www.opengis.net/kml/2.2'
>
<!--

stylesheet to generate kml file with all the sites installed in Uganda
https://maps.google.com/maps?f=q&hl=en&geocode=&q=http://www.epa.gov/mxplorer/All_Facilities.kmz&ie=UTF8&ll=37.439974,-99.228516&spn=60.015586,135&z=4

-->
<xsl:template match='rdf:RDF'>
<kml><Document><Folder><xsl:apply-templates/></Folder></Document></kml>
</xsl:template>
<xsl:template match='mon:Site'>
<Placemark>
	<name><xsl:value-of select='mon:name'/></name>
	<Description><xsl:value-of select='mon:name'/></Description>
	<Point>
		<coordinates><xsl:value-of select='geo:long'/>,<xsl:value-of select='geo:lat'/>,0</coordinates>
	</Point>
</Placemark>
</xsl:template>
</xsl:stylesheet>
