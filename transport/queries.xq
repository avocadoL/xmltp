(: Requêtes XPath :)

(: 1. Trouver tous les itinéraires avec un prix inférieur à 50 EUR :)
//itineraire[prix[number(.) < 50 and @devise = 'EUR']]

(: 2. Lister les réservations faites par un voyageur spécifique :)
//reservation[voyageur = 'Belhad Houda']

(: 3. Identifier les itinéraires qui passent par un arrêt spécifique :)
//itineraire[.//arret/ville = 'Rabat']

(: Requêtes XQuery :)

(: 1. Rapport des réservations par mode de transport :)
let $modes := distinct-values(//mode/@type)
return
<rapport_reservations>
{
    for $mode in $modes
    let $reservations := //reservation[
        @id = //mode[@type = $mode]//itineraire/@id
    ]
    let $total_revenu := sum($reservations/prix/number(.))
    return
    <mode_transport type="{$mode}">
        <nombre_reservations>{count($reservations)}</nombre_reservations>
        <revenu_total devise="EUR">{$total_revenu}</revenu_total>
    </mode_transport>
}
</rapport_reservations>

(: 2. Identifier l'itinéraire le plus emprunté :)
let $itineraires := //itineraire
let $max_reservations := max(
    for $i in $itineraires
    return count(//reservation[itineraire_ref = $i/@id])
)
return
<itineraire_plus_emprunte>
{
    $itineraires[
        @id = //reservation/itineraire_ref[
            count(//reservation[itineraire_ref = current()]) = $max_reservations
        ]
    ]
}
</itineraire_plus_emprunte>

(: 3. Nombre total de réservations par jour :)
for $date in distinct-values(//reservation/date_depart)
let $reservations_jour := //reservation[date_depart = $date]
order by $date
return
<jour date="{$date}">
    <nombre_reservations>{count($reservations_jour)}</nombre_reservations>
</jour> 