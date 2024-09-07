= Preface

The deep complexity of ocean sonar finds applications from a variety of other fields, including physical oceanography, wave propagation theory, signal processing, and statistical detection theory.
The array of colleagues I've had the pleasure to learn from have been in the field almost all their lives,
and they demonstrate a continual spirit of learning.
An academic enthusiast will find this field a never ending ocean of knowledge for study and exploration,
ranging from theoretical discoveries via literature to practical experiences at sea.

One method of measuring an ocean sonar systems's performance is via the sonar equation.
The deceptive simplicity of its additive equation form
is accompanied by the complicated nature of
the calculations and interdependencies of its terms.
For each scenario, assumptions can be made to simplify the complicated computations with the obvious trade-off with accuracy.
However, there is potential for greater damage in a search for high accuracy
due to the variability of reality
combined with a high level of inaccessibility of reality's metrics.
Past a certain point of modelling accuracy,
further attempts at improvement may not be worth the effort,
and at worst solidify the unknown inaccuracy.

The following anonymous quotation hints at levels of comical relief balanced with frustration at the difficulty of such a field:

#quote(block: true, quotes: true, attribution: [Anonymous])[
  A sonar engineer is a person who poses as an expert on the basis of being able to produce with prolific fortitude an infinite series of incomprehensible formulae calculated with micromatic precision from vague assumptions based on debatable figures taken from inconclusive experiments carried out with instruments of problematic accuracy by a person of dubious reliability and questionable mentality.
]

This book serves as an organisation of the author's studies on the field.
Of unarguable value, it is publicised as a provision of reproducible content
of theoretical derivations,
computational implementations of numerical algorithms,
and demonstrable uncertainties with hopefully sound conclusions.
It is also a demonstration of the utility of the Julia programming language,
and a output of the Typst typesetting language.

The Julia programming language seeks to fill a role not addressed by other programming languages.
In the words of its creators:

#quote(
  block: true,
  quotes: true,
  attribution: [
    Why We Created Julia | Jeff Bezanson, Stefan Karpinski, Viral B Shah, Alan Edelman
  ]
)[
  We want a language that's open source, with a liberal license. We want the speed of C with the dynamism of Ruby. We want a language that's homoiconic, with true macros like Lisp, but with obvious, familiar mathematical notation like Matlab. We want something as usable for general programming as Python, as easy for statistics as R, as natural for string processing as Perl, as powerful for linear algebra as Matlab, as good at gluing programs together as the shell. Something that is dirt simple to learn, yet keeps the most serious hackers happy. We want it interactive and we want it compiled.

  (Did we mention it should be as fast as C?)

  While we're being demanding, we want something that provides the distributed power of Hadoop — without the kilobytes of boilerplate Java and XML; without being forced to sift through gigabytes of log files on hundreds of machines to find our bugs. We want the power without the layers of impenetrable complexity. We want to write simple scalar loops that compile down to tight machine code using just the registers on a single CPU. We want to write A*B and launch a thousand computations on a thousand machines, calculating a vast matrix product together.
]

The complexity of ocean sonar has been found to be most easily implemented in the Julia programming language
with its accessibility via the paradigm of multiple dispatch and hierarchical type system,
and its performance via the just-ahead-of-time compilation through the LLVM backend.

The Typst typesetting language is a
relatively new, lightweight, and powerful alternative to LaTeX,
essentially summarised as a Markdown-like language with functions.

The author's search for reason and rigour is hopefully apparent throughout this text.
