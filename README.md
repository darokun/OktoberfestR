# OktoberfestR
### A web application to analyze Oktoberfest data

This shiny app was inspired by a [blog post](https://gresch.github.io/2017/09/14/201701oktoberfest1985-2016/) made by @[gresch](https://gresch.github.io/) about analyzing [Oktoberfest](https://www.wikiwand.com/en/Oktoberfest) data and re-uses some of Gresch's code for the plots.     
**Header image credit**: Oktoberfest by Ana Emília Carneiro Martins on [flickr](https://www.flickr.com/photos/miamartins/15504225795/) - License: [CC BY-NC 2.0](https://creativecommons.org/licenses/by-nc/2.0/)


### About the data set
The app takes data from the [Munich Open Data Portal](https://www.opengov-muenchen.de/dataset/oktoberfest).

The data set contais eight variables:
* The **year** of the Oktoberfest
* The duration of the festival in days (**duration_days**)
* Visitors for each year (**visitor_year**)
* Mean visitors per day for each year (**visitor_day**)
* Mean price for one beer (1 Liter) for each year (**beer_price**)
* Whole amount of beer sold for each year in Liter (**beer_sold**)
* Mean price for one chicken for each year (**chicken_price**)
* Whole amount of chickens sold for each year (**chicken_sold**)

### Packages used
* `shiny`: The R package that makes this web application possible. More info [here](http://shiny.rstudio.com/).
* `tidyverse`: This app uses at least the `dplyr` and `ggplot2` packages. More info [here](https://www.tidyverse.org/).
* `colourpicker`: For choosing the color of the plots. More info [here](https://github.com/daattali/colourpicker).
* `plotly`: For making the plots interactive. More info [here](https://plot.ly/r/).
* `DT`: For making the table look nice and add functionality. More info [here](https://rstudio.github.io/DT/).


### About the author
This shiny app was made by [Daloha Rodriguez-Molina](https://drmolina.netlify.com/).
* **Twitter**: @[darokun](https://twitter.com/darokun)
* **GitHub**: @[darokun](https://github.com/darokun)
* **ORCID**: 0000-0002-5355-0474


### Code and Issues
You may find the code for this shiny app [here](https://github.com/darokun/OktoberfestR).     
If you've found any issues, please click [here](https://github.com/darokun/OktoberfestR/issues) and let me know!


### LICENSE
This web application uses the [MIT License](https://github.com/darokun/OktoberfestR/blob/master/LICENSE).


### To do list:
* fix plot titles and axis labels

