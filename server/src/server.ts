import { Server } from "ws";
import { Evento } from "./Evento";
import { Stanza } from "./stanza";


const server = new Server({
    port: 5000
});

const stanze: Array<Stanza> = [];
server.on("connection", (socket) => {
    console.log("ciao")

    let stanza: Stanza | null = null;
    let nome = "";

    socket.onmessage = (evento) => {
        const messaggio = <Evento>JSON.parse(evento.data as string);
        console.log(messaggio.nomeEvento);
        switch (messaggio.nomeEvento) {
            case "creaStanza":
                const nomeStanza = messaggio.data;
                const index = stanze.findIndex((stanza) => stanza.nomeStanza == nomeStanza)

                if (index < 0) {
                    const s = <Stanza>{ nomeStanza: nomeStanza, partecipanti: [socket] }
                    stanze.push(s)
                    socket.send(JSON.stringify({ nomeEvento: "creazioneStanza", data: {successo: true} }))
                    stanza = s;
                    console.log("successo")
                }
                else
                    socket.send(JSON.stringify({ nomeEvento: "creazioneStanza", data: {successo: false} }))
                

                break;
            case "joinStanza":
                const nome = messaggio.data;

                const stanzaTrovata = stanze.find((s) => s.nomeStanza == nome)

                if (stanzaTrovata) {
                    stanzaTrovata.partecipanti.push(socket)
                    stanza = stanzaTrovata

                    socket.send(JSON.stringify({ nomeEvento: "entrata", data: {successo: true} }))
                    broadCast(stanzaTrovata, "giocatoreEntrato", { nome })
                }
                else
                    socket.send(JSON.stringify({ nomeEvento: "entrata", data:  {successo: false} }))
                break;
            case "tentativo":
                broadCast(stanza as Stanza, "tentativo", messaggio.data)
                break;
            case "statusAggiornato":
                broadCast(stanza as Stanza, "statusAggiornato",messaggio.data)
                break;
        }
    }

    socket.onclose = ()=>{
        let index = stanza?.partecipanti.findIndex((s)=>s == socket);
        if(index != null && index >= 0)
            stanza?.partecipanti.splice(index, 1)
        
        if(stanza?.partecipanti.length == 0){
            index = stanze.findIndex((s)=>s==stanza)
            stanze.splice(index, 1)
            console.log("eliminata " + index);
        }

    }
})



const broadCast = (stanza: Stanza, nomeEvento: string, data: any) => {
    
    stanza.partecipanti.forEach((partecipante) => {
        partecipante.send(JSON.stringify(
            {
                nomeEvento,
                data
            }
        ))
    })
}