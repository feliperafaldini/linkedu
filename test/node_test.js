const neo4j = require("neo4j-driver");

const uri = "neo4j+s://3a9a20be.databases.neo4j.io";
const user = "neo4j";
const password = "dn247sLQrXsruyE7s44ThKPbosQ1qb-ex2BV4vWbn5c";

const driver = neo4j.driver(uri, neo4j.auth.basic(user, password));

async function testConnection() {
    const session = driver.session();

    try {
        const result = await session.run("RETURN \"Conexão bem sucedida!\" AS message");
        const singleRecord = result.records[0];
        const message = singleRecord.get("message");

        console.log(message);

    } catch (error) {
        console.error("Erro ao conectar ao Neo4j", error);
    } finally {
        await session.close();
    }

    await driver.close();
}

testConnection();