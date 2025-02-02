(: Requêtes XPath :)

(: 1. Lister tous les produits d'une catégorie donnée :)
//produit[categorie = 'Informatique']

(: 2. Trouver les vendeurs avec des produits en stock faible :)
//vendeur[.//produit[number(stock) < 5]]

(: 3. Afficher les commandes après une date spécifique :)
//commande[date_achat > '2024-01-01']

(: Requêtes XQuery :)

(: 1. Rapport des commandes par client :)
for $client in distinct-values(//commande/client)
let $commandes := //commande[client = $client]
return
<client_rapport>
    <nom>{$client}</nom>
    <total_depense devise="EUR">
    {
        sum($commandes/total/number(.))
    }
    </total_depense>
    <commandes>
    {
        for $c in $commandes
        return
        <commande id="{$c/@id}">
            <date>{$c/date_achat/text()}</date>
            <montant devise="EUR">{$c/total/text()}</montant>
        </commande>
    }
    </commandes>
</client_rapport>

(: 2. Identifier le produit le plus vendu :)
let $produits := //produit
return
<produit_plus_vendu>
{
    let $max_ventes := max(
        for $p in $produits
        return sum(//produit_commande[@ref = $p/@id]/quantite/number(.))
    )
    return
    for $p in $produits
    let $total_ventes := sum(//produit_commande[@ref = $p/@id]/quantite/number(.))
    where $total_ventes = $max_ventes
    return
    <produit id="{$p/@id}">
        <nom>{$p/nom/text()}</nom>
        <unites_vendues>{$total_ventes}</unites_vendues>
    </produit>
}
</produit_plus_vendu>

(: 3. Calculer le revenu total par vendeur :)
for $vendeur in //vendeur
let $produits_vendeur := $vendeur//produit/@id
let $ventes := //produit_commande[@ref = $produits_vendeur]
return
<vendeur_revenu>
    <nom>{$vendeur/nom/text()}</nom>
    <revenu_total devise="EUR">
    {
        sum(
            for $v in $ventes
            return $v/quantite * $v/prix_unitaire
        )
    }
    </revenu_total>
</vendeur_revenu> 