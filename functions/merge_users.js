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
        const usersRef = db.collection('users');
        const snapshot = await usersRef.get();

        for (const doc of snapshot.docs) {
            const user = doc.data();

            const userResult = await session.run('MERGE (u:User {id: $id}) ON CREATE SET u.name = $name, u.email = $email RETURN u', { id: user.uid, name: user.name, email: user.email });

            if (userResult.records.length > 0) {
                console.log('User já existente: ', user);
            } else {
                console.log('User criado: ', user);
            }
        }
    } catch (error) {
        console.error('Erro ao exportar dados para o NEO4J (Usuários): ', error);
    }

    try {
        const companiesRef = db.collection('companies');
        const snapshot = await companiesRef.get();

        for (const doc of snapshot.docs) {
            const company = doc.data();

            const companiesResult = await session.run('MERGE (c:Companies {id: $id}) ON CREATE SET c.name = $name, c.address = $address RETURN c', { id: company.uid, name: company.name, address: company.address });

            if (companiesResult.records.lenght > 0) {
                constole.log('Empresa já existente: ', company);
            } else {
                console.log('Empresa criada: ', company);
            }
        }
    } catch (error) {
        console.error('Erro ao exportar dados para o NEO4J (Empresas): ', error);
    }

    try {
        const jobsRef = db.collection('jobs');
        const snapshot = await jobsRef.get();

        for (const doc of snapshot.docs) {
            const job = doc.data();

            const jobsResult = await session.run('MERGE (j:Jobs {id: $id}) ON CREATE SET j.company = $company, j.position = $position, j.schedule = $schedule RETURN j', { id: job.id, company: job.company, position: job.position, schedule: job.schedule });

            if (jobsResult.records.length > 0) {
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
        console.error('Erro ao exportar dados para o NEO4J (Jobs/Relações): ', error)
    } finally {
        await session.close();
        await driver.close();
    }
})();