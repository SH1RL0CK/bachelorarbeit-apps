package org.example.project


import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.FormatQuote
import androidx.compose.material.icons.filled.Movie
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import org.example.project.models.Quote
import org.example.project.screens.QuoteDetailScreen
import org.example.project.screens.QuotesScreen
import org.example.project.screens.RandomQuoteScreen
import org.example.project.services.QuotesService
import org.example.project.widgets.QuoteDialog

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun App() {
    var selectedTab by remember { mutableStateOf(0) }
    var showDialog by remember { mutableStateOf(false) }
    var refreshTrigger by remember { mutableStateOf(0) }
    var selectedQuote by remember { mutableStateOf<Quote?>(null) }
    val quotesService = remember { QuotesService() }

    MaterialTheme {
        // Show QuoteDetailScreen as full-screen overlay
        if (selectedQuote != null) {
            QuoteDetailScreen(
                quote = selectedQuote!!,
                quotesService = quotesService,
                onBack = { selectedQuote = null },
                onQuoteUpdated = {
                    refreshTrigger++
                    selectedQuote = null
                }
            )
        } else {
            // Main app with navigation
            Scaffold(
                topBar = {
                    CenterAlignedTopAppBar(
                        title = { Text("CineLines") }
                    )
                },
                bottomBar = {
                    NavigationBar {
                        NavigationBarItem(
                            selected = selectedTab == 0,
                            onClick = { selectedTab = 0 },
                            icon = { Icon(Icons.Default.FormatQuote, contentDescription = null) },
                            label = { Text("Zitate") }
                        )
                        NavigationBarItem(
                            selected = selectedTab == 1,
                            onClick = { selectedTab = 1 },
                            icon = { Icon(Icons.Default.Movie, contentDescription = null) },
                            label = { Text("Zufällig") }
                        )
                    }
                },
                floatingActionButton = {
                    if (selectedTab == 0) {
                        FloatingActionButton(
                            onClick = { showDialog = true }
                        ) {
                            Icon(Icons.Default.Add, contentDescription = "Zitat hinzufügen")
                        }
                    }
                }
            ) { paddingValues ->
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(paddingValues),
                    contentAlignment = Alignment.Center
                ) {
                    when (selectedTab) {
                        0 -> {
                            QuotesScreen(
                                quotesService = quotesService,
                                refreshTrigger = refreshTrigger,
                                onQuoteTap = { quote -> selectedQuote = quote }
                            )
                        }
                        1 -> {
                            RandomQuoteScreen(quotesService = quotesService)
                        }
                    }
                }

                if (showDialog) {
                    QuoteDialog(
                        onSave = { quote ->
                            // Use a coroutine scope to handle the suspend function
                            MainScope().launch {
                                quotesService.addQuote(quote)
                                refreshTrigger++
                                showDialog = false
                            }
                        },
                        onDismiss = { showDialog = false }
                    )
                }
            }
        }
    }
}
