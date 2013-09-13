PRNGS
=====

Messing around with less-uniform pseudo-random number generators.

The base class is the `WeightedPRNG`, which should probably actually be
called a "defined-distribution prng", because at its core, it defines a
finite list of discrete values, and chooses from amongst them.

The poorly-named `BayesianPRNG` changes over time, tending to favour more
commonly selected values.  It achieves this by adding selected values
back to the list of potential values.  I.e. the longer it runs, the more
memory it uses.  If the initial distribution is fairly uniform, it will
only deviate gradually over time.

The `EvolvingPRNG` is like the `BayesianPRNG`, except that its deviation
is much more dramatic.  It achieves this distribution by picking two
values: one from the distribution (the winner), and one from an inversion
of the distribution (the loser).  It then replaces the one instance of
the loser in the distribution list with the winner.  In other words, it
steals from the poor and gives to the rich.

All three classes provide the same basic API as `Random` in the ruby core,
so they can be used, for example, in `Array#shuffle`

