<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
	<document>
		<descrRow>
			<colTest id="1" value="" />
			<colTest id="3" value="not blank" />
			<colTest id="5" value="0" />
			<skip>false</skip>
		</descrRow>
		<rows>
			<xsl:for-each select="supplyList/supply">
				<xsl:sort select="@destDesc"/>
				<row>
					<col>
						<xsl:attribute name="id">1</xsl:attribute>
						<xsl:attribute name="mapid">2</xsl:attribute>
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@artId" />
						</xsl:attribute>
					</col>
					<col>
						<xsl:attribute name="id">2</xsl:attribute>
						<xsl:attribute name="mapid">0</xsl:attribute>
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@artIdCustomer" />
						</xsl:attribute>
					</col>
					<col>
						<xsl:attribute name="id">3</xsl:attribute>
						<xsl:attribute name="mapid">4</xsl:attribute>
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@artDesc" />
						</xsl:attribute>
					</col>
					<col>
						<xsl:attribute name="id">4</xsl:attribute>
						<xsl:attribute name="mapid">0</xsl:attribute>
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@destDesc" />
						</xsl:attribute>
					</col>
					<col>
						<xsl:attribute name="id">5</xsl:attribute>
						<xsl:attribute name="mapid">11</xsl:attribute>
						<xsl:attribute name="type">decimal</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@qty" />
						</xsl:attribute>
					</col>
					<col>
						<xsl:attribute name="id">6</xsl:attribute>
						<xsl:attribute name="mapid">7</xsl:attribute>
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@UM" />
						</xsl:attribute>
					</col>
					<col>
						<xsl:attribute name="id">7</xsl:attribute>
						<xsl:attribute name="mapid">-6</xsl:attribute>
						<xsl:attribute name="type">decimal</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@price" />
						</xsl:attribute>
					</col>
					<col>
						<xsl:attribute name="id">8</xsl:attribute>
						<xsl:attribute name="mapid">6</xsl:attribute>
						<xsl:attribute name="type">date</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@dlvDate" />
						</xsl:attribute>
					</col>
					<col>
						<xsl:attribute name="id">9</xsl:attribute>
						<xsl:attribute name="mapid">-4</xsl:attribute>
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@orderId" />
						</xsl:attribute>
					</col>
					<col>
						<xsl:attribute name="id">10</xsl:attribute>
						<xsl:attribute name="mapid">-5</xsl:attribute>
						<xsl:attribute name="type">integer</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@rowId" />
						</xsl:attribute>
					</col>
				</row>
			</xsl:for-each>
		</rows>
	</document>
</xsl:template>

</xsl:stylesheet>