library(gt)


Lubelskie <- pol |> 
  filter(NAME_1 == "Lubelskie")

Opolskie <- pol |> 
  filter(NAME_1 == "Opolskie")

sample1 <- st_sample(Lubelskie, 10) |> 
  st_as_sf()
sample2 <- st_sample(Opolskie, 10) |> 
  st_as_sf()


samples <- bind_rows(sample1, sample2)

df$location[1:10] <- "Lubelskie"
df$location[11:20] <- "Opolskie"

df2 <- bind_cols(df, samples) |> 
  st_drop_geometry() |> 
  rename("geometry" = x)


write_xlsx(df2,
           path = "./data/testdata2.xlsx")

df |> 
  group_by(gender, v1) |> 
  count() |> 
  pivot_wider(names_from = v1
              , values_from = n) |> 
  rename("Gender" = gender
         , "No" = no
         , "Yes" = yes) |> 
  gt(cols_label = names(df))




