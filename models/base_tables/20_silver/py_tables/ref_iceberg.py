def model(dbt, session):

    for key in sorted(session.sparkContext.getConf().getAll()):
        if "iceberg" in key[0].lower() or "catalog" in key[0].lower():
            print(key)

    return session.range(1)