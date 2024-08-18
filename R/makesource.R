#' @export
makesource <- function(file_to_test){
  if (!fs::dir_exists(here::here("tests", "R"))){
    fs::dir_create(here::here("tests", "R"))
  }

  new_file <- file_to_test |>
    fs::path_file() |>
    fs::path_ext_set(".R")

  new_path <- here::here("tests", "R", new_file)

  if (fs::path_ext(file_to_test) == "qmd"){
    knitr::purl(
      file_to_test,
      output = new_path
    )
  } else if (fs::path_ext(file_to_test == "R")){
    fs::file_copy(
      file_to_test,
      here::here("tests", "R")
    )
  }

  rscript <- readr::read_lines(new_path)
  scrubbed_rscript <- lapply(
    rscript,
    \(x) ifelse(
      stringr::str_detect(x, "runtests", negate = T),
      x,
      ""
    )
  ) |>
    unlist()

  readr::write_lines(
    scrubbed_rscript,
    new_path
  )
}
