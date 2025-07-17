import { Image } from "expo-image";
import { useFocusEffect, useRouter } from "expo-router";
import React, { useCallback, useState } from "react";
import { ActivityIndicator, FlatList, StyleSheet, View } from "react-native";
import { Appbar, FAB, Text, useTheme } from "react-native-paper";
import { SafeAreaView } from "react-native-safe-area-context";
import { QuoteCard } from "../../components/QuoteCard";
import { QuoteDialog } from "../../components/QuoteDialog";
import { Quote } from "../../models/quote";
import { quotesService } from "../../services/quotesService";

export default function QuotesScreen() {
    const theme = useTheme();
    const router = useRouter();
    const [quotes, setQuotes] = useState<Quote[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [isDialogVisible, setIsDialogVisible] = useState(false);

    const loadQuotes = useCallback(async () => {
        try {
            setIsLoading(true);
            setError(null);
            const fetchedQuotes = await quotesService.getQuotes();
            setQuotes(fetchedQuotes);
        } catch (err) {
            setError(err instanceof Error ? err.message : "Unknown error");
        } finally {
            setIsLoading(false);
        }
    }, []);

    const refreshQuotes = useCallback(() => {
        loadQuotes();
    }, [loadQuotes]);

    // Use useFocusEffect to refresh quotes when returning from detail screen
    useFocusEffect(
        useCallback(() => {
            loadQuotes();
        }, [loadQuotes])
    );

    const handleQuoteTap = (quote: Quote) => {
        router.push({
            pathname: "/quote-detail",
            params: { quote: JSON.stringify(quote) },
        });
    };

    const handleAddQuote = () => {
        setIsDialogVisible(true);
    };

    const handleDialogDismiss = () => {
        setIsDialogVisible(false);
    };

    const handleQuoteSave = async (quote: Quote) => {
        try {
            await quotesService.addQuote(quote);
            refreshQuotes();
        } catch (err) {
            console.error("Error saving quote:", err);
        }
    };

    const renderEmptyState = () => (
        <View style={styles.emptyState}>
            <Text
                variant="displaySmall"
                style={{ color: theme.colors.onSurface }}
            >
                📝
            </Text>
            <Text
                variant="headlineSmall"
                style={[styles.emptyTitle, { color: theme.colors.onSurface }]}
            >
                Keine Zitate vorhanden
            </Text>
            <Text
                variant="bodyMedium"
                style={[
                    styles.emptySubtitle,
                    { color: theme.colors.onSurfaceVariant },
                ]}
            >
                Fügen Sie Ihre Lieblingszitate aus Filmen hinzu
            </Text>
        </View>
    );

    const renderError = () => (
        <View style={styles.errorState}>
            <Text
                variant="headlineSmall"
                style={[styles.errorTitle, { color: theme.colors.error }]}
            >
                Fehler
            </Text>
            <Text
                variant="bodyMedium"
                style={[
                    styles.errorMessage,
                    { color: theme.colors.onSurfaceVariant },
                ]}
            >
                {error}
            </Text>
        </View>
    );

    const renderLoading = () => (
        <View style={styles.loadingState}>
            <ActivityIndicator size="large" color={theme.colors.primary} />
        </View>
    );

    const renderQuoteItem = ({ item }: { item: Quote }) => (
        <QuoteCard quote={item} onTap={() => handleQuoteTap(item)} />
    );

    return (
        <SafeAreaView
            style={[
                styles.container,
                { backgroundColor: theme.colors.background },
            ]}
            accessible={false}
        >
            <Appbar.Header
                style={{ backgroundColor: theme.colors.surface }}
                accessibilityRole="header"
                accessibilityLabel="CineLines App-Header"
            >
                <Appbar.Content
                    title="CineLines"
                    titleStyle={{
                        color: theme.colors.onSurface,
                        textAlign: "center",
                    }}
                />
            </Appbar.Header>

            <View style={styles.content} accessible={false}>
                {/* Hero Image */}
                <View
                    style={styles.heroImageContainer}
                    accessibilityRole="image"
                    accessibilityLabel="Kino-Hintergrundbild mit Filmrollen und Projektoren"
                >
                    <Image
                        source={require("@/assets/images/cinema.png")}
                        style={styles.heroImage}
                        contentFit="cover"
                        accessible={true}
                        accessibilityLabel="Kino-Hintergrundbild"
                    />
                </View>

                {/* Content Area */}
                <View
                    style={styles.listContainer}
                    accessible={false}
                    accessibilityLabel="Bereich für Filmzitate"
                >
                    {isLoading ? (
                        renderLoading()
                    ) : error ? (
                        renderError()
                    ) : quotes.length === 0 ? (
                        renderEmptyState()
                    ) : (
                        <FlatList
                            data={quotes}
                            renderItem={renderQuoteItem}
                            keyExtractor={(item) => item.id || item.text}
                            contentContainerStyle={styles.listContent}
                            showsVerticalScrollIndicator={false}
                            accessible={false}
                            accessibilityLabel="Liste der Filmzitate"
                            accessibilityHint="Wischen Sie nach oben oder unten, um durch die Zitate zu navigieren"
                        />
                    )}
                </View>
            </View>

            <FAB
                icon="plus"
                style={styles.fab}
                onPress={handleAddQuote}
                accessibilityLabel="Neues Zitat hinzufügen"
                accessibilityHint="Tippen Sie, um ein neues Filmzitat hinzuzufügen"
                accessibilityRole="button"
            />

            <QuoteDialog
                visible={isDialogVisible}
                onDismiss={handleDialogDismiss}
                onSave={handleQuoteSave}
            />
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    content: {
        flex: 1,
    },
    heroImage: {
        height: 200,
        width: "100%",
    },
    heroImageContainer: {
        height: 200,
        width: "100%",
    },
    heroImageFallback: {
        height: 200,
        justifyContent: "center",
        alignItems: "center",
    },
    heroIcon: {
        fontSize: 64,
        marginBottom: 8,
    },
    heroTitle: {
        fontSize: 18,
        fontWeight: "bold",
    },
    listContainer: {
        marginTop: 16,
        flex: 1,
    },
    listContent: {
        padding: 16,
    },
    emptyState: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        padding: 32,
    },
    emptyTitle: {
        marginTop: 16,
        textAlign: "center",
        fontWeight: "bold",
    },
    emptySubtitle: {
        marginTop: 8,
        textAlign: "center",
    },
    errorState: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        padding: 32,
    },
    errorTitle: {
        marginBottom: 8,
        textAlign: "center",
        fontWeight: "bold",
    },
    errorMessage: {
        textAlign: "center",
    },
    loadingState: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
    },
    fab: {
        position: "absolute",
        margin: 16,
        right: 0,
        bottom: 0, // Account for tab bar
    },
});
