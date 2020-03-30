# Consumo alimentario mensual en los hogares españoles en R

Este respositorio contiene una función para extraer las series mensuales de consumo de alimentos en España por CCAA a partir de los ficheros que publica el ministerio competente [aquí](https://www.mapa.gob.es/es/alimentacion/temas/consumo-y-comercializacion-y-distribucion-alimentaria/panel-de-consumo-alimentario/series-anuales/).

El fichero producto de la descarga tiene cinco columnas:

* `ccaa`: o bien la CCAA (en formato ISO) o el total nacional.
* `fecha`: la fecha del primer día del mes.
* `producto`: la categoría de producto (p.e, huevos de gallina).
* `variable`: la variable recogida. Puede ser una de cinco:

    * `consumo_pc`: consumo per cápita
    * `gasto_pc`: el gasto per cápita
    * `precio_kg`: precio medio del producto por kg o litro según su naturaleza
    * `valor`: el valor total de mercado en miles de euros
    * `volumen`: el volumen total consumido, en miles de kg o litros, según la naturaleza del producto

* `value`: el valor correspondiente

`Nota:` Los ministerios tienen la mala costumbre de modificar urls, formato de ficheros, etc. a su antojo y sin preaviso. Es posible que cuando tú uses el código, este ya no funcione. Te ruego que me avises si es el caso, tanto para comunicármelo como para enviarme el parche que solucione el problema si sabes cómo.
