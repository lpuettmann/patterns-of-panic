# Exploring the "Patterns of Panic" dataset

Links:

- [Working paper](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3156287)

## Data

There are two datasets in this repository:

- *pp_quarterly.csv*: Quarterly dataset
- *pp_monthly.csv*: Monthly dataset

Both datasets are in comma separated files and contain the following variables:

- `year`: Year as number.
- `quarter/month`: Quarter or month as number.
- `date`: Contains date as string.
- `newspapers`: Either uses "all" newspapers or leaves one out at a time. 
- `mood`: Can be "negative", "neutral" or "positive".
- `detrending`: Either no detrending or one of three methods (on the level of newspapers, before averaging).
- `val`: The numerical indicator value.

The baseline indicator takes "all" newspapers, has mood "negative" and uses detrending "none".

## License

For the license on the data, see *LICENSE.txt*. Loosely spoken, you can do with the data as you please, as long as you cite me. 