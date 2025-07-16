import { VideoView, useVideoPlayer } from "expo-video";
import React, { useEffect, useState } from "react";
import { ScrollView, StyleSheet, View } from "react-native";
import {
    ActivityIndicator,
    Appbar,
    Button,
    Card,
    Text,
    useTheme,
} from "react-native-paper";
import { SafeAreaView } from "react-native-safe-area-context";
import { QuoteCard } from "../../components/QuoteCard";
import { Quote } from "../../models/quote";
import { quotesService } from "../../services/quotesService";

export default function RandomQuoteScreen() {
    const theme = useTheme();
    const [currentQuote, setCurrentQuote] = useState<Quote | null>(null);
    const [isLoading, setIsLoading] = useState(true);
    const [hasQuotes, setHasQuotes] = useState(false);

    const player = useVideoPlayer(
        require("../../assets/videos/cinema.mp4"),
        (player) => {
            player.loop = true;
            player.muted = true;
            player.play();
        }
    );

    useEffect(() => {
        loadRandomQuote();
    }, []);

    const loadRandomQuote = async () => {
        setIsLoading(true);

        try {
            const quotes = await quotesService.getQuotes();
            setHasQuotes(quotes.length > 0);

            if (quotes.length > 0) {
                const randomQuote = await quotesService.getRandomQuote();
                setCurrentQuote(randomQuote);
            } else {
                setCurrentQuote(null);
            }
        } catch (error) {
            console.error("Error loading random quote:", error);
            setCurrentQuote(null);
            setHasQuotes(false);
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <SafeAreaView
            style={[
                styles.container,
                { backgroundColor: theme.colors.background },
            ]}
        >
            <Appbar.Header style={{ backgroundColor: theme.colors.surface }}>
                <Appbar.Content
                    title="CineLines"
                    titleStyle={{
                        color: theme.colors.onSurface,
                        textAlign: "center",
                    }}
                />
            </Appbar.Header>

            <ScrollView
                style={styles.content}
                showsVerticalScrollIndicator={false}
            >
                {/* Video Player */}
                <View style={styles.videoContainer}>
                    <VideoView
                        style={styles.video}
                        player={player}
                        contentFit="cover"
                        allowsFullscreen={false}
                        allowsPictureInPicture={false}
                    />
                </View>

                {/* Quote Display */}
                <View style={styles.quoteSection}>
                    {isLoading ? (
                        <Card
                            style={[
                                styles.loadingCard,
                                { backgroundColor: theme.colors.surface },
                            ]}
                        >
                            <Card.Content style={styles.loadingContent}>
                                <ActivityIndicator
                                    size="large"
                                    color={theme.colors.primary}
                                />
                                <Text
                                    variant="bodyLarge"
                                    style={[
                                        styles.loadingText,
                                        { color: theme.colors.onSurface },
                                    ]}
                                >
                                    Lade Zitat...
                                </Text>
                            </Card.Content>
                        </Card>
                    ) : currentQuote ? (
                        <QuoteCard quote={currentQuote} />
                    ) : (
                        <Card
                            style={[
                                styles.emptyCard,
                                { backgroundColor: theme.colors.surface },
                            ]}
                        >
                            <Card.Content style={styles.emptyContent}>
                                <Text
                                    variant="displaySmall"
                                    style={[
                                        styles.emptyIcon,
                                        {
                                            color: theme.colors
                                                .onSurfaceVariant,
                                        },
                                    ]}
                                >
                                    💭
                                </Text>
                                <Text
                                    variant="headlineSmall"
                                    style={[
                                        styles.emptyTitle,
                                        { color: theme.colors.onSurface },
                                    ]}
                                >
                                    Keine Zitate vorhanden
                                </Text>
                                <Text
                                    variant="bodyMedium"
                                    style={[
                                        styles.emptySubtitle,
                                        {
                                            color: theme.colors
                                                .onSurfaceVariant,
                                        },
                                    ]}
                                >
                                    Fügen Sie Ihr erstes Zitat hinzu!
                                </Text>
                            </Card.Content>
                        </Card>
                    )}
                </View>

                {/* Refresh Button */}
                {hasQuotes && (
                    <Button
                        mode="contained"
                        onPress={loadRandomQuote}
                        loading={isLoading}
                        style={[
                            styles.button,
                            { backgroundColor: theme.colors.primary },
                        ]}
                        contentStyle={styles.buttonContent}
                        icon="refresh"
                        disabled={isLoading}
                    >
                        {isLoading ? "Lade..." : "Anderes Zitat"}
                    </Button>
                )}
            </ScrollView>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    header: {
        padding: 20,
        elevation: 2,
    },
    content: {
        flex: 1,
        padding: 16,
    },
    videoContainer: {
        height: 300,
        borderRadius: 12,
        overflow: "hidden",
        marginBottom: 16,
        elevation: 4,
    },
    video: {
        flex: 1,
    },
    quoteSection: {
        marginBottom: 24,
    },
    loadingCard: {
        marginHorizontal: 16,
        marginVertical: 8,
        elevation: 2,
    },
    loadingContent: {
        padding: 32,
        alignItems: "center",
    },
    loadingText: {
        marginTop: 16,
        textAlign: "center",
    },
    emptyCard: {
        marginHorizontal: 16,
        marginVertical: 8,
        elevation: 2,
    },
    emptyContent: {
        padding: 32,
        alignItems: "center",
    },
    emptyIcon: {
        fontSize: 50,
        marginBottom: 16,
    },
    emptyTitle: {
        fontWeight: "bold",
        marginBottom: 8,
        textAlign: "center",
    },
    emptySubtitle: {
        textAlign: "center",
    },
    button: {
        marginHorizontal: 16,
        marginBottom: 16,
    },
    buttonContent: {
        paddingVertical: 8,
    },
});
