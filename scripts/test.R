library(gt)

pol <- st_read("./data/poland/gadm41_POL_1.shp")


Lubelskie <- pol |> 
  filter(NAME_1 == "Lubelskie")

Opolskie <- pol |> 
  filter(NAME_1 == "Opolskie")

sample1 <- st_sample(Lubelskie, 10) |> 
  st_as_sf()
sample2 <- st_sample(Opolskie, 10) |> 
  st_as_sf()


samples <- bind_rows(sample1, sample2)

df <- read_xlsx(here::here("./data/testdata.xlsx"))

df$location[1:10] <- "Lubelskie"
df$location[11:20] <- "Opolskie"

df2 <- bind_cols(df, samples) 

coords <- st_coordinates(df2$x)

df2 <- df2 |> 
  mutate(
    lat = coords[,2]
    , long = coords[,1]
  ) |> 
  select(-x)

df3 <- df2 |> 
  st_as_sf(coords = c("long", "lat")
           , crs = 4326)


write_xlsx(df2,
           path = "./data/testdata2.xlsx")

sites_visited_table <- df |> 
  st_drop_geometry() |> 
  group_by(location, gender) |> 
  count() |> 
  pivot_wider(names_from = gender
              , values_from = n) |> 
  rename("Location" = location
         , "Male" = M
         , "Female" = F
         ) |> 
  gt()


#density plot
ggplot()


#table that breaks data up by type of site visit

df <- read_xlsx(here::here("./data/testdata2.xlsx"))

df$type_visit <- df$type_visit |> 
  recode(`in person` = "in_person"
         , remote = "Remote"
         , telephone = "Telephone")

df_sort <- df |> 
  group_by(location, type_visit, gender) |> 
  count() |> 
  pivot_wider(names_from = gender
              , values_from = n) |> 
  rename("Location" = location
         , "Male" = M
         , "Female" = F
         , "Type of Visit" = type_visit) |> 
 gt(rowname_col = "row"
     , groupname_col = "Type of Visit") |> 
  sub_missing(missing_text = 0)

df_sort

df_sort2 <- df_sort |> 
  summary_rows(groups = "Type of Visit"
               , columns = c("Female", "Male")
               , funs = list(
                 Totals = "sum")
               )

df_sort2
