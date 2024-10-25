(async () => {
    const neo4j = require('neo4j-driver');

    const URI = 'neo4j+s://3a9a20be.databases.neo4j.io';
    const USER = 'neo4j';
    const PASSWORD = 'dn247sLQrXsruyE7s44ThKPbosQ1qb-ex2BV4vWbn5c';

    let driver;
    let session;

    try {
        driver = neo4j.driver(URI, neo4j.auth.basic(USER, PASSWORD));
        session = driver.session();
        const serverInfo = await driver.getServerInfo();
        console.log('Connection estabilished');
        console.log(serverInfo);
    } catch (error) {
        console.error(`Connection error.\n${error}\nCause: ${error.cause}`);
        if (driver) await driver.close()
        return
    }

    try {
        const startTime = Date.now();

        const result = await session.run('MATCH (n) RETURN n;');

        result.records.forEach(record => {
            console.log('Node: ', record.get('n'));
        });

        const endTime = Date.now();

        const timeTaken = (endTime - startTime) / 1000;

        console.log(`Tempo total para coletar todos os dados do neo4j ${timeTaken} segundos`);
    } catch (error) {
        console.error(`Erro ao recuperar dados do neo4j: `, error);
    } finally {
        if (session) await session.close();
        if (driver) await driver.close();
    }
})();