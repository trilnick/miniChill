# miniChill
C++ based chill portion calculator

Itai Trilnick, July 25th 2018

This package has a C++ implementation for calculating chill portions, an important metric in agronomy. It is specially used for bloom prediction in fruit trees. The chill portion calculation is sequential, based on a vector of temperatures. Temperatures need to stay within a certain range for a certain time for a chill portion to "bank". Therefore, this function cannot be vectorized. Alas, loops are incredibly slow in *R*, and I needed to do this many times, so I transformed my existing *R* code to C++ and added this functionality with Rcpp (thanks, [Hadley](http://adv-r.had.co.nz/Rcpp.html)!).

The function is based on a spreadsheet, distributed by Fishman *et al* based on their 1987 paper. There is a comprehensive *R* package for dealing with chill, [*chillR*](https://CRAN.R-project.org/package=chillR), which also has a function for chill portion calculations (function *chilling*). The package seems to be well written, and I have been using some of its functions. However, the *chilling* function requires a data-frame input which I found less convenient for my work, and is coded as an R loop.

At this point, I do not intend to publish this mini package on CRAN. You can download it with `devtools::install.github('trilnick/miniChill')`. I noticed that, even though the compiled files are already in the repository, *R* will try to compile it on its own, and for this you will need Rtools installed. Therefore, I also uploaded *miniChill_1.0.zip*, a binary package compiled on a Windows machine, which you can download and install without Rtools.

I'm happy to get feedback on this function. Send me an email or post an issue here on Github! 
