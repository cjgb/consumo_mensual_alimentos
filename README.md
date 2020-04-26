# Consumo alimentario mensual en los hogares españoles en R

Este repositorio contiene dos _scripts_ de R para extraer las series mensuales de consumo de alimentos en España por CCAA a partir de los ficheros que publica el ministerio competente [aquí](https://www.mapa.gob.es/es/alimentacion/temas/consumo-y-comercializacion-y-distribucion-alimentaria/panel-de-consumo-alimentario/series-anuales/).

Desafortunadamente, el ministerio publica vistas distintas de los mismos datos a través de dos mecanismos distintos. De ahí que haya dos _scripts_.

El primero, `consumo_mensual_alimentos.R` descarga una serie de ficheros `.xls` los combina y produce un fichero final con cinco columnas:

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

El segundo, `descarga_datos_formulario.R` produce un fichero con un formato similar con dos salvedades:

* El histórico es más corto.
* Pero contiene la variable _penetración_, i.e., el porcentaje de hogares que se estima que consumen un determinado producto.

**Nota:** Los ministerios tienen la mala costumbre de modificar urls, formato de ficheros, etc. a su antojo y sin preaviso. Es posible que cuando tú uses el código, este ya no funcione. Te ruego que me avises si es el caso, tanto para comunicármelo como para enviarme el parche que solucione el problema si sabes cómo.
