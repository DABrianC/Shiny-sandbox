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

