# klimaskepsis

[![deploy-shiny](https://github.com/rolfmblindgren/klimaskepsis/actions/workflows/deploy.yml/badge.svg)](https://github.com/rolfmblindgren/klimaskepsis/actions/workflows/deploy.yml)

# Arktisk havis – minimum siden 1979

Denne Shiny-appen viser utviklingen i **arktisk havis ved årlig minimum**
(vanligvis i september), basert på satellittdata fra **1979 og frem til i dag**.

Formålet er ikke å overbevise, men å **vise data på en måte som skiller
mellom kortsiktig variasjon og langsiktig trend**.

---

## Hva vises her?

- **År-for-år-data** for arktisk havis (målt som *extent*, ikke *area*)
- Mulighet for **glatting** (LOESS eller rullerende gjennomsnitt)
- Filtrering på tidsperiode
- Forklarende tekst om hva visualiseringene faktisk betyr

Alle valg er gjort for å minimere retorikk og maksimere lesbarhet.

---

## Viktig begrepsavklaring

### Extent vs. area
Denne appen bruker **extent**:
- arealet der minst 15 % av havoverflaten er dekket av is

Dette er standardmålet brukt av NSIDC og NASA.
Tallene er derfor ikke direkte sammenlignbare med «isareal» rapportert andre steder.

---

## Om år-for-år-variasjon

Arktisk havis varierer betydelig fra år til år.
Dette skyldes blant annet:
- værmønstre
- vind og havstrømmer
- atmosfærisk sirkulasjon (NAO/AO)

Slike svingninger er **forventet** og sier lite alene om klimautvikling.

---

## Hvorfor glatting?

Glatting brukes **kun som et hjelpemiddel for å lese mønstre**, ikke for å endre data.

### LOESS
LOESS (lokal regresjon) tilpasser en glatt kurve basert på nærliggende datapunkter.
Metoden:
- antar ingen bestemt trendform
- egner seg godt til å vise langsiktige bevegelser i støyende data
- er beskrivende, ikke forklarende

### Rullerende gjennomsnitt
Et rullerende gjennomsnitt:
- beregner gjennomsnitt over et fast tidsvindu (f.eks. 5 år)
- demper kortsiktig støy
- gjør det lettere å se utvikling over tid

Ulempen er redusert informasjon i start og slutt av serien.

---

## En vanlig feiltolkning

Det er mulig å velge korte tidsvinduer som:
- ser «flate» ut
- eller gir inntrykk av midlertidig økning

Dette er en velkjent statistisk effekt i dataserier med høy variabilitet.
Langsiktige vurderinger krever **flere tiår med data**, ikke enkeltperioder.

---

## Data og kilde

Dataene stammer fra **NSIDC Sea Ice Index**, basert på konsistente satellittmålinger
som starter i 1979.

Serien er blant de best dokumenterte klimatiske observasjonsseriene vi har.

---

## Hva denne appen ikke gjør

- den modellerer ikke årsaker
- den predikerer ikke framtiden
- den argumenterer ikke politisk

Den viser data, og gir leseren verktøy til å tolke dem.

---

## Lisens og bruk

Koden kan fritt brukes, endres og videreutvikles.
Data tilhører sine respektive kilder og er brukt i henhold til åpen publisering.

---

*Kortversjon:*  
Dette er et forsøk på å gjøre klimadata **kjedelige nok** til å være nyttige.
