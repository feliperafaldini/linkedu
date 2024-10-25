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
        const jobsRef = db.collection('jobs');
        const snapshot = await jobsRef.get();

        for (const doc of snapshot.docs) {
            const job = doc.data();
            const jobsResult = await session.run('MERGE (j:Jobs {id: $id}) ON CREATE SET j.company = $company, j.position = $position, j.schedule = $schedule RETURN j', { id: job.id, company: job.company, position: job.position, schedule: job.schedule });

            if (jobsResult.records.lenght > 0) {
                console.log('Vaga já existente: ', job);
            } else {
                console.log('Vaga criada: ', job);
            }

            const relationResult = await session.run('MATCH (j:Jobs {id: $jobId})\nMATCH(c:Companies {name: $companyName})\nMERGE (j)-[:OPEN_BY]->(c)',
                { jobId: job.id, companyName: job.company }
            );

            if (relationResult.summary.counters.updates().relationshipsCreated > 0) {
                console.log('Relação entre a vaga ' + job.position + ' e a empresa ' + job.company + ' foi criada.');
            } else {
                console.log('Relação entre a vaga ' + job.position + ' e a empresa ' + job.company + ' já existente.');

            }
        }
    } catch (error) {
        console.error('Erro ao exportar dados para o NEO4J (Vagas/Relações): ', error)
    } finally {
        await session.close();
        await driver.close();
    }
})();