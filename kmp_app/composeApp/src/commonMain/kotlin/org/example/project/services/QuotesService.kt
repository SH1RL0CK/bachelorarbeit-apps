package org.example.project.services

import org.example.project.models.Quote
import kotlin.uuid.ExperimentalUuidApi
import kotlin.uuid.Uuid

@OptIn(ExperimentalUuidApi::class)
class QuotesService {
    private val quotes = mutableListOf<Quote>(
        Quote(
            id = "1",
            text = "May the Force be with you.",
            movie = "Star Wars: Episode IV - A New Hope",
            character = "Obi-Wan Kenobi",
            year = 1977,
            rating = 5
        ),
        Quote(
            id = "2",
            text = "I'm going to make him an offer he can't refuse.",
            movie = "The Godfather",
            character = "Don Vito Corleone",
            year = 1972,
            rating = 5
        ),
        Quote(
            id = "3",
            text = "Here's looking at you, kid.",
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