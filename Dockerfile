FROM solr:7.7.2

USER root

RUN apt-get update && apt-get install --no-install-recommends --yes hunspell-hu

# Ensure the Solr home directory exists
RUN mkdir -p /opt/solr/server/solr

# Copy cores to /opt/solr/server/solr/ (default Solr home)
COPY --chown=solr:solr ./var/solr/data/opensemanticsearch /opt/solr/server/solr/opensemanticsearch
COPY --chown=solr:solr ./src/open-semantic-entity-search-api/src/solr/opensemanticsearch-entities /opt/solr/server/solr/opensemanticsearch-entities

COPY etc /etc

# Recreate symbolic links for hunspell (required for Windows compatibility)
RUN ln -sf /usr/share/hunspell /opt/solr/server/solr/opensemanticsearch/conf/lang/
RUN ln -sf /usr/share/hunspell /opt/solr/server/solr/opensemanticsearch-entities/conf/lang/

# Ensure correct permissions
RUN chown -R solr:solr /opt/solr/server/solr

USER solr

# Start Solr (it will automatically load cores from /opt/solr/server/solr)
CMD ["solr", "start", "-f"]
