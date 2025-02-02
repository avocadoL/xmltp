<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Rapport - Marketplace</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    table { border-collapse: collapse; width: 100%; margin-top: 20px; }
                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                    th { background-color: #f2f2f2; }
                    h1, h2, h3 { color: #333; }
                    .section { margin-bottom: 30px; }
                    .stock-warning { color: red; }
                </style>
            </head>
            <body>
                <h1>Rapport - Marketplace</h1>
                
                <!-- Liste des produits par vendeur -->
                <div class="section">
                    <h2>Produits par Vendeur</h2>
                    <xsl:for-each select="//vendeur">
                        <div class="vendeur">
                            <h3>
                                <xsl:value-of select="nom"/>
                                (<xsl:value-of select="pays"/>)
                            </h3>
                            <table>
                                <tr>
                                    <th>Produit</th>
                                    <th>Catégorie</th>
                                    <th>Prix</th>
                                    <th>Stock</th>
                                </tr>
                                <xsl:for-each select="boutique/produit">
                                    <tr>
                                        <td><xsl:value-of select="nom"/></td>
                                        <td><xsl:value-of select="categorie"/></td>
                                        <td>
                                            <xsl:value-of select="prix"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="prix/@devise"/>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="number(stock) &lt; 5">
                                                    <span class="stock-warning">
                                                        <xsl:value-of select="stock"/>
                                                    </span>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="stock"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </table>
                        </div>
                    </xsl:for-each>
                </div>
                
                <!-- Commandes par client -->
                <div class="section">
                    <h2>Commandes par Client</h2>
                    <xsl:for-each select="//commande[not(client = preceding::commande/client)]">
                        <xsl:variable name="client_courant" select="client"/>
                        <div class="client">
                            <h3>Client: <xsl:value-of select="client"/></h3>
                            <table>
                                <tr>
                                    <th>Date</th>
                                    <th>Produits</th>
                                    <th>Total</th>
                                </tr>
                                <xsl:for-each select="//commande[client = $client_courant]">
                                    <tr>
                                        <td><xsl:value-of select="date_achat"/></td>
                                        <td>
                                            <ul>
                                                <xsl:for-each select="produits/produit_commande">
                                                    <li>
                                                        <xsl:value-of select="quantite"/>x 
                                                        <xsl:value-of select="//produit[@id = current()/@ref]/nom"/>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                        <td>
                                            <xsl:value-of select="total"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="total/@devise"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                                <tr>
                                    <td colspan="2"><strong>Total dépensé</strong></td>
                                    <td>
                                        <strong>
                                            <xsl:value-of select="sum(//commande[client = $client_courant]/total)"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="//commande[1]/total/@devise"/>
                                        </strong>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </xsl:for-each>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet> 