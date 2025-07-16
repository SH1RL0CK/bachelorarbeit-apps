package org.example.project.models

data class Quote(
    val id: String? = null,
    val text: String,
    val movie: String,
    val character: String? = null,
    val year: Int? = null,
    val rating: Int = 1,
)