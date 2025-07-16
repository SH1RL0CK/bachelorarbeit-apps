package org.example.project.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FormatQuote
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.launch
import org.example.project.models.Quote
import org.example.project.services.QuotesService
import org.example.project.widgets.QuoteCard
import kotlin.random.Random

@Composable
fun RandomQuoteScreen(
    quotesService: QuotesService = QuotesService()
) {
    var currentQuote by remember { mutableStateOf<Quote?>(null) }
    var isLoading by remember { mutableStateOf(true) }
    var quotes by remember { mutableStateOf<List<Quote>>(emptyList()) }

    val scope = rememberCoroutineScope()

    suspend fun loadRandomQuote() {
        try {
            isLoading = true
            quotes = quotesService.getQuotes()
            if (quotes.isNotEmpty()) {
                val randomIndex = Random.nextInt(quotes.size)
                currentQuote = quotes[randomIndex]
            } else {
                currentQuote = null
            }
        } catch (e: Exception) {
            // Handle error
            currentQuote = null
        } finally {
            isLoading = false
        }
    }

    LaunchedEffect(Unit) {
        loadRandomQuote()
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {
        // Video placeholder (since video player is platform-specific)
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .height(300.dp),
            shape = RoundedCornerShape(12.dp),
            colors = CardDefaults.cardColors(containerColor = Color.Black)
        ) {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "Video Background",
                    color = Color.White,
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Medium
                )
            }
        }

        // Random Quote Card
        when {
            isLoading -> {
                Box(
                    modifier = Modifier.fillMaxWidth(),
                    contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator()
                }
            }
            currentQuote != null -> {
                QuoteCard(
                    quote = currentQuote!!,
                    onTap = null // Disable tap for random screen
                )
            }
            else -> {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Default.FormatQuote,
                            contentDescription = null,
                            modifier = Modifier.size(50.dp),
                            tint = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                        )
                        Spacer(modifier = Modifier.height(16.dp))
                        Text(
                            text = "Keine Zitate vorhanden",
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold,
                            color = MaterialTheme.colorScheme.onSurface
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Fügen Sie Ihr erstes Zitat hinzu!",
                            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.7f)
                        )
                    }
                }
            }
        }

        // Refresh Button (Get Another Random Quote)
        if (currentQuote != null) {
            Button(
                onClick = {
                    scope.launch {
                        loadRandomQuote()
                    }
                },
                modifier = Modifier.fillMaxWidth(),
                enabled = !isLoading
            ) {
                Icon(Icons.Default.Refresh, contentDescription = null)
                Spacer(modifier = Modifier.width(8.dp))
                Text("Anderes Zitat")
            }
        }
    }
}