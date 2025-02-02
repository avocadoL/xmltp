<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:key name="produits-par-categorie" match="produit" use="categorie"/>
    
    <xsl:template match="/">
        <produits_par_categorie>
            <xsl:for-each select="//produit[generate-id() = generate-id(key('produits-par-categorie', categorie)[1])]">
                <xsl:sort select="categorie"/>
                <categorie>
                    <nom><xsl:value-of select="categorie"/></nom>
                    <produits>
                        <xsl:for-each select="key('produits-par-categorie', categorie)">
                            <produit id="{@id}">
                                <nom><xsl:value-of select="nom"/></nom>
                                <description><xsl:value-of select="description"/></description>
                                <vendeur>
                                    <nom><xsl:value-of select="ancestor::vendeur/nom"/></nom>
                                    <pays><xsl:value-of select="ancestor::vendeur/pays"/></pays>
                                </vendeur>
                                <prix devise="{prix/@devise}">
                                    <xsl:value-of select="prix"/>
                                </prix>
                                <stock><xsl:value-of select="stock"/></stock>
                                <statistiques>
                                    <ventes_totales>
                                        <xsl:value-of select="sum(//produit_commande[@ref = current()/@id]/quantite)"/>
                                    </ventes_totales>
                                    <revenu_total devise="{prix/@devise}">
                                        <xsl:value-of select="sum(//produit_commande[@ref = current()/@id]/quantite) * prix"/>
                                    </revenu_total>
                                </statistiques>
                            </produit>
                        </xsl:for-each>
                        <statistiques_categorie>
                            <nombre_produits>
                                <xsl:value-of select="count(key('produits-par-categorie', categorie))"/>
                            </nombre_produits>
                            <prix_moyen devise="EUR">
                                <xsl:value-of select="sum(key('produits-par-categorie', categorie)/prix) div count(key('produits-par-categorie', categorie))"/>
                            </prix_moyen>
                            <stock_total>
                                <xsl:value-of select="sum(key('produits-par-categorie', categorie)/stock)"/>
                            </stock_total>
                        </statistiques_categorie>
                    </produits>
                </categorie>
            </xsl:for-each>
        </produits_par_categorie>
    </xsl:template>
</xsl:stylesheet> 