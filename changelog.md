= Simple Signature CHANGELOG

== Version 1.0.2 (December 17, 2013)

- Allow SimpleSignature::Generator to be instantiated without a block. This enables to reuse a generator, but it is needed to call generator.reset! before attempting to generate a new signature, otherwise, the previous data and timestamp will remain.

== Version 1.0.1 (December 17, 2013)

- When using SimpleSignature::RequestValidator with a request containing query_string, the query parameters will be sorted.

== Version 1.0.0 (December 13, 2013)

- First commit.
