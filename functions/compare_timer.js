(async () => {
    const admin = require('firebase-admin');
    var serviceAccount = require('./service_account_key.json');

    admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

    const firestore = admin.firestore();

    const neo4j = require('neo4j-driver');

    const URI = 'neo4j+s://3a9a20be.databases.neo4j.io';
    const USER = 'neo4j';
    const PASSWORD = 'dn247sLQrXsruyE7s44ThKPbosQ1qb-ex2BV4vWbn5c';

    let driver;
    let session;


    try {
        const startTimeFirebase = Date.now();

        const collections = await firestore.listCollections();

        for (const collection of collections) {
            const snapshot = await collection.get();
            const docs = snapshot.docs;
        }

        const endTimeFirebase = Date.now()

        const timeTakenFirebase = (endTimeFirebase - startTimeFirebase) / 1000;

        console.log(`Tempo total para coletar todos os dados do firestore ${timeTakenFirebase} segundos.`);
    } catch (error) {
        console.error('Erro ao recuperar dados do firebase: ', error);
    }


    try {
        driver = neo4j.driver(URI, neo4j.auth.basic(USER, PASSWORD));
        session = driver.session();
    } catch (error) {
        console.error(`Connection error.\n${error}\nCause: ${error.cause}`);
        if (driver) await driver.close()
        return
    }

    try {
        const startTimeNeo4j = Date.now();

        const result = await session.run('MATCH (n) RETURN n;');

        const endTimeNeo4j = Date.now();

        const timeTakenNeo4j = (endTimeNeo4j - startTimeNeo4j) / 1000;

        console.log(`Tempo total para coletar todos os dados do neo4j ${timeTakenNeo4j} segundos`);
    } catch (error) {
        console.error(`Erro ao recuperar dados do neo4j: `, error);
    } finally {
        if (session) await session.close();
        if (driver) await driver.close();
    }

})();