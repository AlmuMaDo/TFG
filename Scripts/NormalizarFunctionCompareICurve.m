function promedio_allPatients_norm = NormalizarFunctionCompareICurve(promedio_allPatients, t0, tf)
% funcion para normalizar las muestras 
% t0 sera el valor de "tiempo" inicial una vez normalizado
% tf sera el valor de "tiempo" final una vez normalizado

%% inicializar estructura salida
promedio_allPatients_norm = promedio_allPatients;

%% frecuencia muestreo normalizada
% ver cuantas muestras se han tomado en total y sacar la nueva frecuencia 
% de muestreo normalizada para la escala entre t0 y tf

n_samples = numel(promedio_allPatients.time);
% new_frec = (tf - t0)/n_samples;

%% reescalar tiempo para normalizar entre t0 y tf
promedio_allPatients_norm.time = linspace(t0, tf, n_samples)';
end
