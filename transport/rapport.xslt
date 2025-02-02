<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Rapport - Plateforme de Transport</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    table { border-collapse: collapse; width: 100%; margin-top: 20px; }
                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                    th { background-color: #f2f2f2; }
                    h1, h2 { color: #333; }
                    .section { margin-bottom: 30px; }
                </style>
            </head>
            <body>
                <h1>Rapport - Plateforme de Transport</h1>
                
                <!-- Liste des itinéraires par mode -->
                <div class="section">
                    <h2>Itinéraires par Mode de Transport</h2>
                    <xsl:for-each select="//modes_transport/mode">
                        <h3><xsl:value-of select="@type"/></h3>
                        <table>
                            <tr>
                                <th>ID</th>
                                <th>Départ</th>
                                <th>Arrivée</th>
                                <th>Prix</th>
                            </tr>
                            <xsl:for-each select="itineraire">
                                <tr>
                                    <td><xsl:value-of select="@id"/></td>
                                    <td><xsl:value-of select="depart"/></td>
                                    <td><xsl:value-of select="arrivee"/></td>
                                    <td>
                                        <xsl:value-of select="prix"/>
                                        <xsl:value-of select="prix/@devise"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </xsl:for-each>
                </div>
                
                <!-- Tableau récapitulatif -->
                <div class="section">
                    <h2>Statistiques Globales</h2>
                    <table>
                        <tr>
                            <th>Mode de Transport</th>
                            <th>Nombre d'Itinéraires</th>
                            <th>Nombre de Réservations</th>
                            <th>Revenu Total</th>
                        </tr>
                        <xsl:for-each select="//statistiques/reservations_par_mode/mode_stat">
                            <tr>
                                <td><xsl:value-of select="@type"/></td>
                                <td>
                                    <xsl:value-of select="count(//mode[@type=current()/@type]/itineraire)"/>
                                </td>
                                <td><xsl:value-of select="."/></td>
                                <td>
                                    <xsl:value-of select="sum(//mode[@type=current()/@type]//prix)"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="//revenu_total/@devise"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet> 