(async () => {
    const functions = require("firebase-functions");
    const admin = require("firebase-admin");
    const neo4j = require("neo4j-driver");

    admin.initializeApp();

    const URI = functions.config().neo4j.uri;
    const USER = functions.config().neo4j.user;
    const PASSWORD = functions.config().neo4j.password;

    const db = admin.firestore();

    exports.compareTime = functions.https.onRequest(async (req, res) => {
        let driver;
        let session;

        try {
            const startTimeFirebase = Date.now();

            const collections = await admin.firestore().listCollections();

            for (const collection of collections) {
                const snapshot = await collection.get();
                const docs = snapshot.docs;
            }

            const endTimeFirebase = Date.now();

            const timeTakenFirebase = (endTimeFirebase - startTimeFirebase) / 1000;

            console.log(`Tempo total para coletar todos os dados do Firestore: ${timeTakenFirebase} segundos.`);

            driver = neo4j.driver(URI, neo4j.auth.basic(USER, PASSWORD));

            session = driver.session();

            const startTimeNeo4j = Date.now();

            const result = await session.run("MATCH (n) RETURN n;");

            const endTimeNeo4j = Date.now();

            const timeTakenNeo4j = (endTimeNeo4j - startTimeNeo4j) / 1000;

            console.log(`Tempo total para coletar todos os dados do neo4j ${timeTakenNeo4j} segundos`);

            res.send(`Tempo total para coletar todos os dados do Firestore: ${timeTakenFirebase} segundos.<br>Tempo total para coletar todos os dados do neo4j: ${timeTakenNeo4j} segundos`)

        } catch (error) {
            console.error(`Erro ao recuperar dados: `, error);
            res.status(500).send(`Erro ao executar função.`)
        } finally {
            if (session) await session.close();
            if (driver) await driver.close();
        }
    });

    exports.syncData = functions.https.onRequest(async (req, res) => {
        try {
            const driver = neo4j.driver(URI, neo4j.auth.basic(USER, PASSWORD));
            var session = driver.session();
            const serverInfo = await driver.getServerInfo();
            console.log("Connection estabilished");
            console.log(serverInfo);
        } catch (error) {

            console.log(`Connection error\n${error}\nCause: ${error.cause}`);
            await driver.close();
            return res.status(500).send(`Erro ao conectar ao banco de dados neo4j.`);
        }

        try {
            const usersRef = db.collection("users");
            const snapshot = await usersRef.get();

            for (const doc of snapshot.docs) {
                const user = doc.data();

                const userResult = await session.run("MERGE (u:User {id: $id}) ON CREATE SET u.name = $name, u.email = $email RETURN u", { id: user.uid, name: user.name, email: user.email });

                if (userResult.records.length > 0) {
                    console.log("User já existente: ", user);
                } else {
                    console.log("User criado: ", user);
                }
            }
        } catch (error) {
            console.error("Erro ao exportar dados para o NEO4J (Usuários): ", error);
            return res.status(500).send(`Erro ao exportar dados para o NEO4J (Usuários)`);
        }

        try {
            const companiesRef = db.collection("companies");
            const snapshot = await companiesRef.get();

            for (const doc of snapshot.docs) {
                const company = doc.data();

                const companiesResult = await session.run("MERGE (c:Companies {id: $id}) ON CREATE SET c.name = $name, c.address = $address RETURN c", { id: company.uid, name: company.name, address: company.address });

                if (companiesResult.records.lenght > 0) {
                    constole.log("Empresa já existente: ", company);
                } else {
                    console.log("Empresa criada: ", company);
                }
            }
        } catch (error) {
            console.error("Erro ao exportar dados para o NEO4J (Empresas): ", error);
            return res.status(500).send(`Erro ao exportar dados para o NEO4J (Empresas)`);
        }

        try {
            const jobsRef = db.collection("jobs");
            const snapshot = await jobsRef.get();

            for (const doc of snapshot.docs) {
                const job = doc.data();

                const jobsResult = await session.run("MERGE (j:Jobs {id: $id}) ON CREATE SET j.company = $company, j.position = $position, j.schedule = $schedule RETURN j", { id: job.id, company: job.company, position: job.position, schedule: job.schedule });

                if (jobsResult.records.length > 0) {
                    console.log("Vaga já existente: ", job);
                } else {
                    console.log("Vaga criada: ", job);
                }

                const relationResult = await session.run("MATCH (j:Jobs {id: $jobId})\nMATCH(c:Companies {name: $companyName})\nMERGE (j)-[:OPEN_BY]->(c)",
                    { jobId: job.id, companyName: job.company }
                );

                if (relationResult.summary.counters.updates().relationshipsCreated > 0) {
                    console.log("Relação entre a vaga " + job.position + " e a empresa " + job.company + " foi criada.");
                } else {
                    console.log("Relação entre a vaga " + job.position + " e a empresa " + job.company + " já existente.");
                }
            }
        } catch (error) {
            console.error("Erro ao exportar dados para o NEO4J (Vagas/Relações): ", error)
            return res.status(500).send(`Erro ao exportar dados para o NEO4J (Vagas/Relações)`);
        } finally {
            await session.close();
            await driver.close();
        }

        res.status(200).send(`Sincronização concluida.`)
    });
})();