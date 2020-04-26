######################################################################################
# @gilbellosta, 2020-04-26
# descarga y procesa datos de consumo y distribución alimentaria mensuales
######################################################################################

library(httr)
library(rvest)
library(plyr)

ccaa <- c(22, 26, 32, 23, 37, 33, 28, 30, 21, 29, 31, 35, 27, 25, 36, 34, 24)
periodo <- 1:78
grupo <- 1:28

combinaciones <- expand.grid(ccaa = ccaa, periodo = periodo, grupo = grupo)
combinaciones <- apply(combinaciones, 1, as.list)


get_data <- function(ccaa, periodo, grupo){
    
    tmp_file <- paste0(paste(c(ccaa, periodo, grupo), collapse = "-"), ".rds")
    print(tmp_file)
    
    url <- "https://www.mapa.gob.es/app/consumo-en-hogares/resultado.asp"
    
    r <- GET(url, query = list(CCAA = ccaa, AA=11, periodo=periodo, grupo=grupo))
    txt <- content(r, "text", encoding = "latin1")
    doc <- read_html(txt)
    tablas <- html_nodes(doc, "table")
    
    # t1 <- html_table(tablas[[1]])
    t2 <- html_table(tablas[[2]])
    
    periodo <- html_node(doc, xpath = '//*[@id="app_section"]/div[10]/div/strong[2]')
    periodo <- html_text(periodo)
    
    t2$periodo <- periodo
    
    ccaa <- html_node(doc, xpath = '//*[@id="app_section"]/div[8]/div/strong[2]') 
    ccaa <- html_text(ccaa)
    t2$ccaa <- ccaa
    
    t2$grupo <- grupo
    
    tmp_file <- file.path("/var/tmp/datos_consumo_hogares/", tmp_file)
    saveRDS(t2, file = tmp_file)
    
    t2
}

res <- lapply(combinaciones, function(x) do.call(get_data, x))

saveRDS(res, file.path("/var/tmp/datos_consumo_hogares/", "all.rds"))

tmp <- lapply(res, function(x){
    colnames(x) <- c("producto", "volumen", "valor", "precio_kg", "penetracion", "consumo_pc", "gasto_pc", "periodo", "ccaa", "grupo")
    x[-1,]
})

tmp <- do.call(rbind, tmp)

foo <- function(x) {
    x <- gsub("\\.", "", x)
    x <- gsub(",",  ".", x)
    as.numeric(x)
}

tmp$volumen <- foo(tmp$volumen)
tmp$valor <- foo(tmp$valor)
tmp$precio_kg <- foo(tmp$precio_kg)
tmp$penetracion <- foo(tmp$penetracion)
tmp$consumo_pc <- foo(tmp$consumo_pc)
tmp$gasto_pc <- foo(tmp$gasto_pc)

fecha <- strsplit(tmp$periodo, " ")
tmp$anno <- 2000 + sapply(fecha, function(x) as.numeric(x[[2]]))
tmp$mes  <- sapply(fecha, function(x) x[[1]])

meses <- c(ENERO = 1, FEBRERO = 2, MARZO = 3, ABRIL = 4, MAYO = 5, JUNIO = 6, JULIO = 7, AGOSTO = 8, SEPTIEMBRE = 9, OCTUBRE = 10, NOVIEMBRE = 11, DICIEMBRE = 12)

fecha <- paste(tmp$anno, meses[tmp$mes], 1, sep = "-")
tmp$fecha <- as.Date(fecha)
    
tmp$anno <- tmp$mes <- NULL
tmp$periodo <- NULL
