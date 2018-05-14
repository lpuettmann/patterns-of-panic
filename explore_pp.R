library(tidyverse)
library(zoo)

# Load data and convert "date" variable to proper date type
pp <- read_csv("pp_quarterly.csv") %>% 
  mutate(date = as.yearqtr(date))

# Define some annotations
annot_ww <- tribble(
  ~xmin, ~xmax, ~name,
  as.Date("1914-07-28"), as.Date("1918-11-11"), "WW1",
  as.Date("1939-09-01"), as.Date("1945-09-02"), "WW2"
)

annot_pp <- tribble(
  ~x, ~y, ~label,
  #--------------
  "1889 Q1", 100.3, "1890 Q4", 
  "1896 Q1", 100.1, "1894 Q1", # Panic of 1893
  "1905 Q1", 99.8, "1900 Q1",
  "1910 Q3", 100.6, "1913 Q2",
  "1925 Q1", 100.6, "1926 Q1",
  "1926 Q4", 101.2, "1929 Q4",
  "1932 Q4", 103.0, "1933 Q1",
  "1974 Q2", 101.65, "1974 Q4",
  "1982 Q3", 102.5, "1982 Q3", # Mexican 1982 debt crisis
  "1988 Q2", 102, "1987 Q4", # Black Monday
  "1993 Q1", 102.8, "1997 Q4", # Asian Financial Crisis
  "2002 Q4", 102.9, "2001 Q4",
  "2008 Q4", 104.8, "2008 Q4", # Global Financial Crisis
  "2013 Q2", 103.7, "2009 Q1", 
  "2014 Q1", 102.8, "2011 Q3", # Euro debt crisis + US debt-ceiling crisis
  "2015 Q3", 101.1, "2015 Q3"  # Greece IMF bankruptcy
) %>% 
  mutate(x = as.yearqtr(x),
         label = as.yearqtr(label))

# Get baseline indicator
baseline <- pp %>% 
  filter(newspapers == "all",
         mood == "negative",
         detrending == "none") %>% 
  full_join(annot_pp, by = c("date" = "label"))

ggplot() + 
  geom_rect(aes(xmin = as.yearqtr(xmin), xmax = as.yearqtr(xmax),
                ymin = -Inf, ymax = Inf), data = annot_ww, fill = "gray80",
            alpha = 0.6) +
  geom_hline(yintercept = 100, size = 0.3, color = "grey80") +
  geom_line(data = baseline, aes(date, val), alpha = 0.8) +
  geom_point(data = baseline %>% filter(!is.na(x)), aes(date, val),
             color = "#ca0020", size = 1.6, alpha = 0.8, stroke = 0) +
  geom_text(data = annot_pp, aes(label = label, x = x, y = y),
            size = 2, family = "Palatino", color = "#ca0020", 
            fontface = "bold") +
  theme_minimal() +
  theme(axis.text.x=element_text(colour="black"),
        axis.text.y=element_text(colour="black")) +
  scale_x_continuous(breaks = seq(1860, 2015, by=10)) +
  geom_rug(data = baseline, aes(date, val), sides = "r", size = 0.5, alpha = 0.3,
           position = "jitter") +
  geom_rug(data = baseline %>% filter(!is.na(x)), color = "#ca0020",
           aes(date, val), sides = "r", size = 0.6) +
  labs(title = "Financial stress indicator", subtitle = "1889-2016, quarterly", 
       x = NULL, y = NULL, 
       caption = paste0("Note: Normalized share of negative newspaper language about",
                        "\n financial markets, averaged across five newspapers."))
