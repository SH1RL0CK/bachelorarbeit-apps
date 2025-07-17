package org.example.project.services

import org.example.project.models.Quote
import kotlin.uuid.ExperimentalUuidApi
import kotlin.uuid.Uuid

@OptIn(ExperimentalUuidApi::class)
class QuotesService {
    private val quotes = mutableListOf<Quote>(
        Quote(
            id = "1",
            text = "Möge die Macht mit dir sein.",
            movie = "Krieg der Sterne",
            character = "Obi-Wan Kenobi",
            year = 1977,
            rating = 5
        ),
        Quote(
            id = "2",
            text = "Ich werde ihm ein Angebot machen, das er nicht ablehnen kann.",
            movie = "Der Pate",
            character = "Don Vito Corleone",
            year = 1972,
            rating = 5
        ),
        Quote(
            id = "3",
            text = "Schau mir in die Augen, Kleines.",
            movie = "Casablanca",
            character = "Rick Blaine",
            year = 1942,
            rating = 4
        )
    )

    suspend fun getQuotes(): List<Quote> {
        return quotes.toList()
    }

    suspend fun addQuote(quote: Quote) {
        val newQuote = quote.copy(id = Uuid.random().toString())
        quotes.add(newQuote)
    }

    suspend fun updateQuote(quote: Quote) {
        val index = quotes.indexOfFirst { it.id == quote.id }
        if (index != -1) {
            quotes[index] = quote
        }
    }

    suspend fun deleteQuote(id: String) {
        quotes.removeAll { it.id == id }
    }
}