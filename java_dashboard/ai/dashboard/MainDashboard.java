package ai.dashboard;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;

public class MainDashboard extends JFrame {
    private JCheckBox aiModeCheckBox;
    private JButton sendCommandButton;
    private JButton aiSignalButton;
    private JButton manualBuyButton;
    private JButton manualSellButton;
    private JTextArea statusArea;
    private final String controlFile = "C:\\Users\\Ahmed\\AppData\\Roaming\\MetaQuotes\\Terminal\\010E047102812FC0C18890992854220E\\MQL5\\Files\\control.txt";

    public MainDashboard() {
        setTitle("MQL5 EA Java Dashboard");
        setSize(400, 300);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLayout(new BorderLayout());

        aiModeCheckBox = new JCheckBox("Enable AI Trading Mode");
        sendCommandButton = new JButton("Send Command");
        aiSignalButton = new JButton("Get AI Signal");
        manualBuyButton = new JButton("Manual BUY");
        manualSellButton = new JButton("Manual SELL");
        statusArea = new JTextArea();
        statusArea.setEditable(false);

        JPanel topPanel = new JPanel();
        topPanel.add(aiModeCheckBox);
        topPanel.add(sendCommandButton);
        topPanel.add(aiSignalButton);
        topPanel.add(manualBuyButton);
        topPanel.add(manualSellButton);
        add(topPanel, BorderLayout.NORTH);
        add(new JScrollPane(statusArea), BorderLayout.CENTER);

        sendCommandButton.addActionListener(e -> sendCommand());
        aiSignalButton.addActionListener(e -> fetchAISignal());
        manualBuyButton.addActionListener(e -> sendTradeCommand("BUY"));
        manualSellButton.addActionListener(e -> sendTradeCommand("SELL"));
    }

    private void sendCommand() {
        String cmd = aiModeCheckBox.isSelected() ? "AI_ON" : "AI_OFF";
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(controlFile))) {
            writer.write(cmd);
            statusArea.append("Sent command: " + cmd + "\n");
        } catch (IOException ex) {
            statusArea.append("Error writing command: " + ex.getMessage() + "\n");
        }
    }

    private void fetchAISignal() {
        String signal = AIAgentConnector.getAISignal();
        statusArea.append("AI Agent Signal: " + signal + "\n");
        if (aiModeCheckBox.isSelected() && (signal.equalsIgnoreCase("BUY") || signal.equalsIgnoreCase("SELL"))) {
            sendTradeCommand(signal);
        }
    }

    private void sendTradeCommand(String signal) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(controlFile))) {
            writer.write(signal.toUpperCase());
            statusArea.append("Sent trade command: " + signal.toUpperCase() + "\n");
        } catch (IOException ex) {
            statusArea.append("Error writing trade command: " + ex.getMessage() + "\n");
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new MainDashboard().setVisible(true);
        });
    }
}
