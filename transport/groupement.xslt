<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:key name="reservations-par-itineraire" match="reservation" use="itineraire_ref"/>
    
    <xsl:template match="/">
        <groupement_reservations>
            <xsl:for-each select="//itineraire">
                <xsl:variable name="itineraire_id" select="@id"/>
                <itineraire id="{$itineraire_id}">
                    <informations>
                        <mode><xsl:value-of select="../@type"/></mode>
                        <depart><xsl:value-of select="depart"/></depart>
                        <arrivee><xsl:value-of select="arrivee"/></arrivee>
                        <prix devise="{prix/@devise}"><xsl:value-of select="prix"/></prix>
                    </informations>
                    <reservations>
                        <xsl:for-each select="key('reservations-par-itineraire', $itineraire_id)">
                            <reservation id="{@id}">
                                <voyageur><xsl:value-of select="voyageur"/></voyageur>
                                <date_depart><xsl:value-of select="date_depart"/></date_depart>
                                <prix devise="{prix/@devise}"><xsl:value-of select="prix"/></prix>
                            </reservation>
                        </xsl:for-each>
                    </reservations>
                    <statistiques>
                        <nombre_reservations>
                            <xsl:value-of select="count(key('reservations-par-itineraire', $itineraire_id))"/>
                        </nombre_reservations>
                        <revenu_total devise="{prix/@devise}">
                            <xsl:value-of select="sum(key('reservations-par-itineraire', $itineraire_id)/prix)"/>
                        </revenu_total>
                    </statistiques>
                </itineraire>
            </xsl:for-each>
        </groupement_reservations>
    </xsl:template>
</xsl:stylesheet> 