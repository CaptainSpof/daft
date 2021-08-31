+++
title = "Random Ramble"
description = "Generating random nonsense, because of reasons."
date = 2021-08-30
[taxonomies]
categories = ["Project"]
tags = ["rust", "generator", "wip"]

[extra]
comments = false
toc = true
+++

<center> <h1>🏗 We be Wipping 🏗</h1> </center>

In the life of an agile project, the most exiting aspect of it is, by far, naming the sprint… Well, no, terminating a sprint is better, because there's the celebration at the pub afterward.

Still, naming a sprint is important. So much so that my coworkers often find themselves frozen by the responsibility of finding a good, meaningful name. Or maybe it was total disinterest and boredom.

Anyway, I came up with a solution to these problems. Introducing `RandomRamble`.

<details>
    <summary>*Cough*</summary>
    <p>In reality, I just wanted a pretext to play around with Rust.</p>
</details>

<!-- more -->

## Silliness Automated

So yeah, the goal of this project was initially, to help us come up with a name for our sprints. We decided to take some inspiration from the naming of Ubuntu version, where every six months they unveil a new iteration labeled with an adjective and an animal specie name, both starting with the same letter. As of the time of writing the last release is dubbed "Hirsute Hippo", with "Impish Indri", just around the corner.

But we couldn't just blatantly plagiarized Canonical. So we settled with an adjective followed by a superhero name (and also Disney character because peer pressure).

## `cargo new`

Let's get this started, shall we?

### Who do I want in my team?

> If you say "cli", I say "clap", if you say "how to make sens out of a seamingly unordered data in a clean and efficient way", I say er "serde".

When I started this toy project I didn't knew much of Rust ecosystem (still don't but eh) except that `clap` and `serde` are great and they got their place right there in the `Cargo.toml`.

## Is it any good, though?

No.
