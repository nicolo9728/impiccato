import WebSocket from "ws";

export interface Stanza{
    nomeStanza: string,
    partecipanti: Array<WebSocket>
}