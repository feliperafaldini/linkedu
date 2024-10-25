(async () => {
    var express = require('express');
    var admin = require('firebase-admin');
    var neo4j = require('neo4j-driver');
    var serviceAccount = require('./service_account_key.json');

    const app = express();
    const port = 3000;

    // URI examples: 'neo4j://localhost', 'neo4j+s://xxx.databases.neo4j.io'
    const URI = 'neo4j+s://3a9a20be.databases.neo4j.io'
    const USER = 'neo4j'
    const PASSWORD = 'dn247sLQrXsruyE7s44ThKPbosQ1qb-ex2BV4vWbn5c'
    let driver, session

    admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

    const db = admin.firestore();

    app.get('/sync', async (req, res) => {

        try {
            driver = neo4j.driver(URI, neo4j.auth.basic(USER, PASSWORD))
            session = driver.session()
            const serverInfo = await driver.getServerInfo()
            console.log('Connection established')
            console.log(serverInfo)
        } catch (err) {
            console.log(`Connection error\n${err}\nCause: ${err.cause}`)
            await driver.close()
            return
        }

        // Use the driver to run queries
        // EXPORTA USUARIOS PARA O NEO4J
        try {
            const usersRef = db.collection('users');
            const snapshot = await usersRef.get();

            for (const doc of snapshot.docs) {
                const user = doc.data();

                const userResult = await session.run('MERGE (u:User {id: $id}) ON CREATE SET u.name = $name, u.email = $email RETURN u', { id: user.uid, name: user.name, email: user.email });

                if (userResult.records.length > 0) {
                    console.log('User já existente: ', user)
                } else { console.log('User criado: ', user) }

            }
        } catch (error) {
            console.error('Erro ao exportar dados para o neo4j: ', error);
        }

        // EXPORTA EMPRESAS PARA O NEO4J
        try {
            const companiesRef = db.collection('companies');
            const snapshot = await companiesRef.get();

            for (const doc of snapshot.docs) {
                const company = doc.data()

                const companiesResult = await session.run('MERGE (c:Companies {id: $id}) ON CREATE SET c.name = $name, c.address = $address RETURN c', { id: company.uid, name: company.name, address: company.address });

                if (companiesResult.records.length > 0) {
                    console.log('Empresa já existente: ', company)
                } else { console.log('Empresa criada: ', company) }

            }
        } catch (error) {
            console.error('Erro ao exportar dados para o neo4j: ', error);
        }

        // EXPORTA VAGAS PARA O NEO4J
        try {
            const jobsRef = db.collection('jobs');
            const snapshot = await jobsRef.get();

            for (const doc of snapshot.docs) {
                const job = doc.data()

                const jobResult = await session.run('MERGE (j:Jobs {id: $id}) ON CREATE SET j.company = $company, j.position = $position, j.schedule = $schedule RETURN j', { id: job.id, company: job.company, position: job.position, schedule: job.schedule });
                if (jobResult.records.length > 0) {
                    console.log('Vaga já existente: ', job)
                } else { console.log('Vaga criada: ', job) }

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
            console.error('Erro ao exportar dados para o neo4j: ', error);
        } finally {
            await session.close();
            await driver.close();
        }

        res.send('Sincronização realizada.');
    })

    app.listen(port, () => {
        console.log('Servidor rodando em http://localhost:' + port);
    })
})();