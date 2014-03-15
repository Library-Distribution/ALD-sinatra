before do
  # may need exceptions later (e.g. images, application/x-ald-package, ...)
  halt unless request.preferred_type(ALD::OUTPUT_TYPES)
end