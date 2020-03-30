######################################################################################
# @gilbellosta, 2020-03-30
# descarga y procesa datos de consumo y distribución alimentaria mensuales
######################################################################################

library(rvest)
library(readxl)
library(reshape2)

url_base <- "https://www.mapa.gob.es/"
url_rel  <- "es/alimentacion/temas/consumo-y-comercializacion-y-distribucion-alimentaria/panel-de-consumo-alimentario/series-anuales/"

get_urls <- function(){
    tmp <- read_html(paste0(url_base, url_rel))
    tmp <- html_nodes(tmp, xpath = "//body//a")
    tmp <- html_attr(tmp, "href")
    tmp <- grep("datosmensualesconsumohogares", tmp, value = TRUE)
    
    urls <- paste0(url_base, tmp)
}


procesa_fichero <- function(url){
    my_year <- gsub(".*([0-9]{4})_.*", "\\1", url)
    
    message("my_year: ", my_year)
    
    file_name <- file.path(tempdir(), paste0(my_year, ".xlsx"))
    
    tmp <- download.file(url, file_name)
    if (tmp == 0)
        message("File downloaded at ", file_name)
    else
        stop("Problem downloading file at ", url)
    
    res <- lapply(1:12, procesa_mes, file_name, my_year)
    
    do.call(rbind, res)
}


procesa_mes <- function(mes, fichero, anno){
    
    message("Reading month ", mes)
    
    x <- try({
        tmp  <- colnames(read_xlsx(fichero, sheet = mes + 1, skip = 1))
        ccaa <- tmp[-1][seq(1, length(tmp) - 1, by = 5)]
        ccaa <- c("", rep(ccaa, each = 5))
        
        suppressMessages(out <- read_xlsx(fichero, sheet = mes + 1, skip = 2))
        tmp <- gsub("\\..*", "", colnames(out))
        tmp <- paste(ccaa, tmp, sep = "|")
        
        colnames(out) <- tmp
        colnames(out)[1] <- "producto"
        out <- melt(out, id.vars = "producto")
        
        out$ccaa <- gsub("\\|.*", "", out$variable)
        out$variable <- gsub("^.*\\|", "", out$variable)
        out$fecha <- as.Date(paste(anno, mes, "1", sep = "-"))
    }, silent = TRUE)
    
    
    if (inherits(x, "try-error"))
        return(NULL)
    
    out
}


urls <- get_urls()

res <- do.call(rbind, lapply(urls, procesa_fichero))

# backup <- res


res$ccaa[grep("ANDALU", res$ccaa)] <- "an"
res$ccaa[grep("ARAG", res$ccaa)] <- "ar"
res$ccaa[grep("ASTU", res$ccaa)] <- "as"
res$ccaa[grep("CANARIA", res$ccaa)] <- "cn"
res$ccaa[grep("CANTA", res$ccaa)] <- "cb"
res$ccaa[grep("MANCHA", res$ccaa)] <- "cm"
res$ccaa[grep("CASTILLA", res$ccaa)] <- "cl"
res$ccaa[grep("CATALU", res$ccaa)] <- "ct"
res$ccaa[grep("EXTREMA", res$ccaa)] <- "ex"
res$ccaa[grep("GALICIA", res$ccaa)] <- "ga"
res$ccaa[grep("BALE", res$ccaa)] <- "ib"
res$ccaa[grep("RIOJA", res$ccaa)] <- "ri"
res$ccaa[grep("MADR", res$ccaa)] <- "md"
res$ccaa[grep("MURC", res$ccaa)] <- "mc"
res$ccaa[grep("NAVA", res$ccaa)] <- "nc"
res$ccaa[grep("VASCO", res$ccaa)] <- "pv"
res$ccaa[grep("VALEN", res$ccaa)] <- "vc"

res$ccaa[grep("ESPA", res$ccaa)] <- "españa"

res$variable[grep("CONSUMO", res$variable)] <- "consumo_pc"
res$variable[grep("GASTO", res$variable)]   <- "gasto_pc"
res$variable[grep("PRECIO", res$variable)]   <- "precio_kg"
res$variable[grep("VALOR", res$variable)]   <- "valor"
res$variable[grep("VOLUMEN", res$variable)]   <- "volumen"







