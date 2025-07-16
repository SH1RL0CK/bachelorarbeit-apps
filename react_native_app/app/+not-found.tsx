import { Link, Stack } from "expo-router";
import { StyleSheet } from "react-native";
import { Button, Surface, Text, useTheme } from "react-native-paper";
import { SafeAreaView } from "react-native-safe-area-context";

export default function NotFoundScreen() {
    const theme = useTheme();

    return (
        <>
            <Stack.Screen options={{ title: "Oops!" }} />
            <SafeAreaView
                style={[
                    styles.container,
                    { backgroundColor: theme.colors.background },
                ]}
            >
                <Surface
                    style={[
                        styles.surface,
                        { backgroundColor: theme.colors.surface },
                    ]}
                >
                    <Text
                        variant="headlineMedium"
                        style={[
                            styles.title,
                            { color: theme.colors.onSurface },
                        ]}
                    >
                        Diese Seite existiert nicht.
                    </Text>
                    <Text
                        variant="bodyMedium"
                        style={[
                            styles.subtitle,
                            { color: theme.colors.onSurfaceVariant },
                        ]}
                    >
                        Die angeforderte Seite konnte nicht gefunden werden.
                    </Text>
                    <Link href="/(tabs)" asChild>
                        <Button
                            mode="contained"
                            style={styles.button}
                            icon="home"
                        >
                            Zur Startseite
                        </Button>
                    </Link>
                </Surface>
            </SafeAreaView>
        </>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: "center",
        justifyContent: "center",
        padding: 20,
    },
    surface: {
        padding: 24,
        borderRadius: 16,
        alignItems: "center",
        elevation: 4,
        minWidth: 280,
    },
    title: {
        textAlign: "center",
        marginBottom: 8,
        fontWeight: "bold",
    },
    subtitle: {
        textAlign: "center",
        marginBottom: 24,
    },
    button: {
        marginTop: 8,
    },
});
