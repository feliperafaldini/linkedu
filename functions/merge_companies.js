(async () => {
    const admin = require('firebase-admin');
    const neo4j = require('neo4j-driver');
    const serviceAccount = require('./service_account_key.json');

    const URI = 'neo4j+s://3a9a20be.databases.neo4j.io';
    const USER = 'neo4j';
    const PASSWORD = 'dn247sLQrXsruyE7s44ThKPbosQ1qb-ex2BV4vWbn5c';

    admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

    const db = admin.firestore();

    try {
        const driver = neo4j.driver(URI, neo4j.auth.basic(USER, PASSWORD));
        var session = driver.session();
        const serverInfo = await driver.getServerInfo();

        console.log('Connection estabilished');
        console.log(serverInfo);

    } catch (error) {
        console.log(`Connection error\n${error}\nCause: ${error.cause}`);
        await driver.close();
        return
    }

    try {
        const companiesRef = db.collection('companies');
        const snapshot = await companiesRef.get();

        for (const doc of snapshot.docs) {
            const company = doc.data();
            const companiesResult = await session.run('MERGE (c:Companies {id: $id}) ON CREATE SET c.name = $name, c.address = $address RETURN c', { id: company.uid, name: company.name, address: company.address });

            if (companiesResult.records.length > 0) {
                console.log('Empresa já existente: ', company);
            } else {
                console.log('Empresa criada: ', company);
            }
        }
    } catch (error) {
        console.error('Erro ao exportar dados para o NEO4J (Empresas): ', error);
    } finally {
        await session.close();
        await driver.close();
    }
})();