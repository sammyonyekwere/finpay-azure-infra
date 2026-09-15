MODULES := networking database cache keyvault registry container_app monitoring

.PHONY: docs
docs:
	@for m in $(MODULES); do \
		echo "generating docs/reference/modules/$$m.md"; \
		terraform-docs markdown table \
			--config .terraform-docs.yml \
			--output-file $(CURDIR)/docs/reference/modules/$$m.md \
			$(CURDIR)/modules/$$m; \
	done
