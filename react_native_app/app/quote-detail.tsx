import { useLocalSearchParams, useRouter } from "expo-router";
import React, { useState } from "react";
import { ScrollView, StyleSheet } from "react-native";
import {
    Appbar,
    Button,
    Dialog,
    Portal,
    Snackbar,
    Text,
    TextInput,
    useTheme,
} from "react-native-paper";
import { SafeAreaView } from "react-native-safe-area-context";
import { StarRating } from "../components/StarRating";
import { Quote } from "../models/quote";
import { quotesService } from "../services/quotesService";

export default function QuoteDetailScreen() {
    const theme = useTheme();
    const router = useRouter();
    const params = useLocalSearchParams();

    // Parse the quote from params
    const quote = JSON.parse(params.quote as string) as Quote;

    const [text, setText] = useState(quote.text);
    const [movie, setMovie] = useState(quote.movie);
    const [character, setCharacter] = useState(quote.character || "");
    const [year, setYear] = useState(quote.year?.toString() || "");
    const [rating, setRating] = useState(quote.rating);
    const [errors, setErrors] = useState<{ text?: string; movie?: string }>({});
    const [snackbarVisible, setSnackbarVisible] = useState(false);
    const [snackbarMessage, setSnackbarMessage] = useState("");
    const [snackbarColor, setSnackbarColor] = useState("success");
    const [deleteDialogVisible, setDeleteDialogVisible] = useState(false);

    const validateForm = (): boolean => {
        const newErrors: { text?: string; movie?: string } = {};

        if (!text.trim()) {
            newErrors.text = "Bitte geben Sie den Zitat-Text ein";
        }

        if (!movie.trim()) {
            newErrors.movie = "Bitte geben Sie den Namen des Films ein";
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const showSnackbar = (
        message: string,
        color: "success" | "error" = "success"
    ) => {
        setSnackbarMessage(message);
        setSnackbarColor(color);
        setSnackbarVisible(true);
    };

    const handleSaveChanges = async () => {
        if (validateForm()) {
            try {
                const updatedQuote: Quote = {
                    ...quote,
                    text: text.trim(),
                    movie: movie.trim(),
                    character: character.trim() || undefined,
                    year: year ? parseInt(year, 10) || undefined : undefined,
                    rating,
                };

                await quotesService.updateQuote(updatedQuote);
                showSnackbar("Änderungen gespeichert");

                // Navigate back with result
                setTimeout(() => {
                    router.back();
                }, 1500);
            } catch (error) {
                showSnackbar(`Fehler beim Speichern: ${error}`, "error");
            }
        }
    };

    const handleDeleteQuote = () => {
        setDeleteDialogVisible(true);
    };

    const confirmDeleteQuote = async () => {
        try {
            await quotesService.deleteQuote(quote.id!);
            showSnackbar("Zitat gelöscht");
            setDeleteDialogVisible(false);

            // Navigate back with delete result
            setTimeout(() => {
                router.back();
            }, 1500);
        } catch (error) {
            showSnackbar(`Fehler beim Löschen: ${error}`, "error");
            setDeleteDialogVisible(false);
        }
    };

    const cancelDeleteQuote = () => {
        setDeleteDialogVisible(false);
    };

    return (
        <SafeAreaView
            style={[
                styles.container,
                { backgroundColor: theme.colors.background },
            ]}
        >
            <Appbar.Header style={{ backgroundColor: theme.colors.surface }}>
                <Appbar.BackAction onPress={() => router.back()} />
                <Appbar.Content
                    title="Zitat Details"
                    titleStyle={{ color: theme.colors.onSurface }}
                />
            </Appbar.Header>

            <ScrollView
                style={styles.content}
                contentContainerStyle={styles.contentContainer}
            >
                <TextInput
                    label="Zitat*"
                    placeholder="Geben Sie den Zitat-Text ein"
                    value={text}
                    onChangeText={setText}
                    mode="outlined"
                    multiline
                    numberOfLines={3}
                    error={!!errors.text}
                    style={styles.input}
                />
                {errors.text && (
                    <Text
                        variant="bodySmall"
                        style={[
                            styles.errorText,
                            { color: theme.colors.error },
                        ]}
                    >
                        {errors.text}
                    </Text>
                )}

                <TextInput
                    label="Charakter"
                    placeholder="Wer hat das Zitat gesagt?"
                    value={character}
                    onChangeText={setCharacter}
                    mode="outlined"
                    style={styles.input}
                />

                <TextInput
                    label="Film/Serie*"
                    placeholder="Name des Films oder der Serie"
                    value={movie}
                    onChangeText={setMovie}
                    mode="outlined"
                    error={!!errors.movie}
                    style={styles.input}
                />
                {errors.movie && (
                    <Text
                        variant="bodySmall"
                        style={[
                            styles.errorText,
                            { color: theme.colors.error },
                        ]}
                    >
                        {errors.movie}
                    </Text>
                )}

                <TextInput
                    label="Jahr"
                    placeholder="z.B. 2004"
                    value={year}
                    onChangeText={setYear}
                    mode="outlined"
                    keyboardType="numeric"
                    style={styles.input}
                    maxLength={4}
                />

                <Text
                    variant="bodyLarge"
                    style={[
                        styles.ratingLabel,
                        { color: theme.colors.onSurface },
                    ]}
                >
                    Zitat bewerten:
                </Text>

                <StarRating
                    rating={rating}
                    onRatingChanged={setRating}
                    starSize={28}
                    isEditable={true}
                />

                <Button
                    mode="contained"
                    onPress={handleSaveChanges}
                    style={[
                        styles.saveButton,
                        { backgroundColor: theme.colors.primary },
                    ]}
                    icon="content-save"
                    contentStyle={styles.buttonContent}
                >
                    Änderungen speichern
                </Button>

                <Button
                    mode="contained"
                    onPress={handleDeleteQuote}
                    style={[
                        styles.deleteButton,
                        { backgroundColor: theme.colors.error },
                    ]}
                    icon="delete"
                    contentStyle={styles.buttonContent}
                >
                    Zitat löschen
                </Button>
            </ScrollView>

            <Snackbar
                visible={snackbarVisible}
                onDismiss={() => setSnackbarVisible(false)}
                duration={3000}
                style={{
                    backgroundColor:
                        snackbarColor === "success"
                            ? "#4CAF50"
                            : theme.colors.error,
                }}
            >
                {snackbarMessage}
            </Snackbar>

            <Portal>
                <Dialog
                    visible={deleteDialogVisible}
                    onDismiss={cancelDeleteQuote}
                    style={{ backgroundColor: theme.colors.surface }}
                >
                    <Dialog.Title style={{ color: theme.colors.onSurface }}>
                        Zitat löschen
                    </Dialog.Title>
                    <Dialog.Content>
                        <Text
                            variant="bodyMedium"
                            style={{ color: theme.colors.onSurfaceVariant }}
                        >
                            Möchten Sie dieses Zitat wirklich löschen?
                        </Text>
                    </Dialog.Content>
                    <Dialog.Actions>
                        <Button onPress={cancelDeleteQuote}>Abbrechen</Button>
                        <Button
                            mode="contained"
                            onPress={confirmDeleteQuote}
                            style={{ backgroundColor: theme.colors.error }}
                        >
                            Löschen
                        </Button>
                    </Dialog.Actions>
                </Dialog>
            </Portal>
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
    contentContainer: {
        padding: 24,
    },
    input: {
        marginBottom: 16,
    },
    errorText: {
        marginTop: -12,
        marginBottom: 8,
        marginLeft: 12,
    },
    ratingLabel: {
        marginTop: 16,
        marginBottom: 12,
        fontWeight: "600",
    },
    saveButton: {
        marginTop: 32,
        marginBottom: 16,
    },
    deleteButton: {
        marginBottom: 16,
    },
    buttonContent: {
        paddingVertical: 8,
    },
});
