(async () => {
    const { onSchedule } = require("firebase-functions/v2/scheduler");
    const { logger } = require("firebase-functions");
    var admin = require("firebase-admin");
    var neo4j = require("neo4j-driver");
    var serviceAccount = require("./service_account_key.json");

    // URI examples: "neo4j://localhost", "neo4j+s://xxx.databases.neo4j.io"
    const URI = "neo4j+s://3a9a20be.databases.neo4j.io"
    const USER = "neo4j"
    const PASSWORD = "dn247sLQrXsruyE7s44ThKPbosQ1qb-ex2BV4vWbn5c"
    let driver, session

    admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

    const db = admin.firestore();

    try {
        driver = neo4j.driver(URI, neo4j.auth.basic(USER, PASSWORD))
        session = driver.session()
        const serverInfo = await driver.getServerInfo()
        console.log("Connection established")
        console.log(serverInfo)
    } catch (err) {
        console.log(`Connection error\n${err}\nCause: ${err.cause}`)
        await driver.close()
        return
    }

    // Use the driver to run queries
    exports.exportToNeo4j = onSchedule("every minute", async (event) => {
        try {
            const usersRef = db.collection("users");
            const snapshot = await usersRef.get();

            for (const doc of snapshot.docs) {
                const user = doc.data();

                await session.run("CREATE (u:User {id: $id, name: $name, email: $email})", { id: user.uid, name: user.name, email: user.email });
                console.log("User criado: $user", { user: user })
            }
        } catch (error) {
            console.error("Erro ao exportar dados para o neo4j: ", error);
        } finally {
            await session.close();
            await driver.close();
        }
    })
})();